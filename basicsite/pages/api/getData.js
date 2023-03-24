import mysql from "mysql2/promise";

export default async function handler(req,res){
    const dbconnection = await mysql.createConnection({
        host:process.env.DB_HOST,
        database:process.env.DB_NAME,
        port:process.env.DB_PORT,
        user:process.env.DB_USER,
        password:process.env.DB_PASSWORD,
    });
    try {


        const query = "SELECT test, title, bodytext FROM blogposts;"
        const values = []
        const [data] = await dbconnection.execute(query,values)
        dbconnection.end()

        res.status(200).json({results: data})
    }   catch (error){
        res.status(500).json({error: error.message})
    }
}