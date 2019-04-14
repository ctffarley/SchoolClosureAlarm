from flask import Flask, jsonify
from scrape import next_close

app = Flask(__name__)

closed = True

@app.route('/api/closure', methods=['GET'])
def get_date():
    date = next_close()
    # date[1] = date[1].replace(',', '') commented out for fake data
    if closed:
        return jsonify({
            "month": date[0],
            "num": int(date[1]),
            "year": int(date[2])
        })
    else:
        return jsonify({
            "month": "March",
            "num": 18,
            "year": 2019
        })

@app.route('/api/switch', methods=['POST'])
def switch_date():
    global closed
    closed = not closed

if __name__ == '__main__':
    app.run(debug=True)
