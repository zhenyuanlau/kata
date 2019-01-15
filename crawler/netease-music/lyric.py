#!/usr/bin/env python3

# import sys
# sys.path.append('/Users/zhenyuanlau/GitHub/kata/crawler/netease-music/')
# import demo
# import importlib
# importlib.reload(demo)

from bs4 import BeautifulSoup
import os
import re
import requests

def http_get(url):
  headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
    'Referer': 'http://music.163.com',
    'Host': 'music.163.com'
  }

  try:
    return requests.get(url, headers = headers)
  except:
    print('request error')
    pass

def get_artist_info(html):
  soup = BeautifulSoup(html, 'lxml')
  links = soup.find('ul', class_ = 'f-hide').find_all('a')
  song_ids = []
  song_names = []
  for link in links:
    song_id = link.get('href').split('=')[-1]
    song_name = link.get_text()
    song_ids.append(song_id)
    song_names.append(song_name)
  return zip(song_names, song_ids)

def get_lyric(song_id):
  url = f'http://music.163.com/api/song/lyric?id={str(song_id)}&lv=1&kv=1&tv=-1'
  response = http_get(url).json()
  initial_lyric = response['lrc']['lyric']
  regex = re.compile(r'\[.*\]')
  final_lyric = re.sub(regex, '', initial_lyric).strip()
  return final_lyric

def write_lyric(song_name, lyric):
  print(f'正在写入歌曲: {song_name}')
  with open(f'{os.getcwd()}/crawler/lyrics/{song_name}.txt', 'a', encoding='utf-8') as fp:
    fp.write(lyric)

if __name__ == '__main__':
  artist_id = input('请输入艺人 ID: ')
  artist_url = f'http://music.163.com/artist?id={artist_id}'
  response = http_get(artist_url).text
  artist_infos = get_artist_info(response)
  for artist_info in artist_infos:
    lyric = get_lyric(artist_info[1])
    write_lyric(artist_info[0], lyric)
