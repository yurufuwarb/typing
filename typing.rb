# -*- coding: utf-8 -*-
require 'csv'

#----------------------------------------
# タイピング定義
#----------------------------------------
definitions_ja = []
definitions_roma = []

CSV.foreach('definitions.csv') do |row|
  definitions_ja << row[0]
  definitions_roma << row[1]
end

#----------------------------------------
# タイピング
#----------------------------------------
TITLE = "たった100行のタイピングゲーム"
Shoes.app(title: TITLE, width: 900,resizable: false) do
  background white

  # ランダムに円を描く
  fill rgb(0, 0.6, 0.9, 0.1)
  stroke rgb(0, 0.6, 0.9)
  strokewidth 0.25
  140.times do
    oval( left:   (-5..self.width).rand,
          top:    (-5..self.height).rand,
          radius: (25..50).rand)
  end

  # 入力フィールド
  @line = edit_line(width: 0, height: 0)

  # ゲーム開始確認
  exit if !confirm('Are you ready?')

  # 正解タイプ数、ミスタイプ数
  good = 0
  mistake = 0

  stack :margin => 0.1 do
    background white
    @line.focus
    index = Random.rand definitions_ja.length

    stack :margin => 12 do
      ja = subtitle(strong(definitions_ja[index]),:font => "MS Gothic")
      roma = tagline(definitions_roma[index], :font =>"Arial Black")

      @line.change do |input|
        if input.text.downcase == roma.text[0].downcase
          good += 1
          roma.text = roma.text[1..roma.text.length]
        else
          mistake += 1
        end

        input.text = ""

        if roma.text.length == 0
          index = Random.rand definitions_ja.length
          ja.text = definitions_ja[index]
          roma.text = definitions_roma[index]
        end
      end
    end
  end

  stack :margin => 0.1 do
    caption(strong("制限時間"),:font => "MS Gothic")
    p = progress :width => 1.0
    a = animate(5) do |i|
      p.fraction = (i % 100) / 100.0
      next if i < 100

      # アニメーション終了
      a.stop

      # タイピング結果画面
      dialog(title: TITLE, width: 500, resizable: false) do
        background white

        # ランダムに円を描く
        fill rgb(0, 0.6, 0.9, 0.1)
        stroke rgb(0, 0.6, 0.9)
        strokewidth 0.25
        60.times do
          oval( left:   (-5..self.width).rand,
                top:    (-5..self.height).rand,
                radius: (25..50).rand)
        end

        stack :margin => 0.1 do
          score = good * 3
          ratio = (good.to_f / (good + mistake).to_f) * 100
          rank = "C"
          if score >= 360 && ratio >= 99.5
            rank = "SS"
          elsif score >= 330 && ratio >= 98
            rank = "S"
          elsif score >= 300 && ratio >= 96.5
            rank = "A"
          elsif score >= 270 && ratio >= 94
            rank = "B"
          end

          subtitle(strong("得点        ：#{score}"),:font => "MS Gothic")
          subtitle(strong("ランク      ：#{rank}"),:font => "MS Gothic")
          subtitle(strong("正解タイプ数：#{good}回"),:font => "MS Gothic")
          subtitle(strong("ミスタイプ数：#{mistake}回"),:font => "MS Gothic")
          subtitle(strong("正解率      ：#{ratio.round(1)}％"),:font => "MS Gothic")
        end

        stack :margin_left => '30%' do
          button "おしまい" do
            exit
          end
        end

      end   # dialog(...) do
    end     # animate(...) do
  end
end


