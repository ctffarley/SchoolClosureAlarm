from flask import Flask, jsonify
from scrape import next_close

app = Flask(__name__)

@app.route('/api/closure', methods=['GET'])
def get_date():
    date = next_close()
    date[1] = date[1].replace(',', '')
    return jsonify({
        "month": date[0],
        "num": int(date[1]),
        "year": int(date[2])
    })

if __name__ == '__main__':
    app.run(debug=True)
