from bs4 import BeautifulSoup
import json
import os
import re
import requests

def get_html(url):
  headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
    'Referer': 'http://music.163.com',
    'Host': 'music.163.com'
  }

  try:
    response = requests.get(url, headers = headers)
    html = response.text
    return html
  except:
    print('request error')
    pass

def get_singer_info(html):
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
  url = 'http://music.163.com/api/song/lyric?' + 'id=' + str(song_id) + '&lv=1&kv=1&tv=-1'
  html = get_html(url)
  json_obj = json.loads(html)
  initial_lyric = json_obj['lrc']['lyric']
  regex = re.compile(r'\[.*\]')
  final_lyric = re.sub(regex, '', initial_lyric).strip()
  return final_lyric

def write_text(song_name, lyric):
  print('正在写入歌曲: {}'.format(song_name))
  with open('{}/crawler/lyrics/{}.txt'.format(os.getcwd(), song_name), 'a', encoding='utf-8') as fp:
    fp.write(lyric)

if __name__ == '__main__':
  singer_id = input('请输入歌手ID:')
  start_url = 'http://music.163.com/artist?id={}'.format(singer_id)
  html = get_html(start_url)
  singer_infos = get_singer_info(html)
  for singer_info in singer_infos:
    lyric = get_lyric(singer_info[1])
    write_text(singer_info[0], lyric)
