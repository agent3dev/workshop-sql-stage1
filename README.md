# 🦕 DinoPark SQL Workshop — Stage 1

Welcome to **DinoPark**, a Jurassic-style database where you manage dinosaurs, species, and enclosures.

By the end of this session you will have:
- A real PostgreSQL database running on your machine
- A visual tool (pgAdmin) to explore it
- Written your first SQL queries

---

## Step 0 — Install the tools (do this once)

### WSL 2 (Windows Subsystem for Linux)

Open **PowerShell as Administrator** and run:

```powershell
wsl --install
```

Restart your computer when prompted. This installs WSL 2 with Ubuntu by default.  
After restarting, Ubuntu will open and ask you to create a Linux username and password.

> If WSL is already installed, make sure you have Ubuntu: `wsl --install -d Ubuntu`

### Docker Desktop

Download and install from: https://www.docker.com/products/docker-desktop/

During installation, make sure **"Use WSL 2 instead of Hyper-V"** is checked.  
After installation, open Docker Desktop → **Settings → Resources → WSL Integration** and enable it for Ubuntu.

Restart Docker Desktop and wait until you see **"Engine running"** in the bottom-left corner.

> **Mac users:** Docker Desktop works the same way. Skip the WSL steps.

---

## Step 1 — Get the workshop files

Open **Ubuntu** (search for it in the Start menu — this is your WSL terminal) and run:

```bash
git clone https://github.com/agent3dev/workshop-sql-stage1.git
cd workshop-sql-stage1
```

Git is already installed in Ubuntu — no extra steps needed.

---

## Step 2 — Start the database

Still in the Ubuntu terminal, inside the `workshop-sql-stage1` folder:

```bash
docker compose up -d
```

This will:
1. Download PostgreSQL and pgAdmin images (first time takes ~2 minutes)
2. Start two containers: `dinopark_db` and `dinopark_pgadmin`
3. Automatically create the tables and load the dinosaur data

**Verify it's running:**

```bash
docker compose ps
```

You should see both containers with status `running`.

---

## Step 3 — Connect with pgAdmin (visual interface)

1. Open your browser and go to: **http://localhost:8080**
2. Log in:
   - Email: `ranger@dinopark.com`
   - Password: `trex1234`
3. In the left panel, right-click **Servers** → **Register** → **Server...**
4. Fill in:
   - **General → Name:** `DinoPark`
   - **Connection → Host:** `db`
   - **Connection → Port:** `5432`
   - **Connection → Username:** `ranger`
   - **Connection → Password:** `trex1234`
5. Click **Save**

You should now see the `dinopark` database in the tree on the left.

---

## Step 4 — Open the Query Tool

In pgAdmin:
1. Expand **DinoPark → Databases → dinopark**
2. Click on `dinopark` to select it
3. Click the **Query Tool** button (the lightning bolt icon in the toolbar)

A text editor opens. This is where you write SQL.

---

## Step 5 — Your first query

Type this in the Query Tool and press **F5** (or click the ▶ button):

```sql
SELECT * FROM dinosaurs;
```

You should see 23 dinosaurs. **You're in.**

---

## Step 6 — Connect from the terminal (optional)

```bash
docker exec -it dinopark_db psql -U ranger -d dinopark
```

Now you can type SQL directly in the terminal. Type `\q` to exit.

> This is useful for quick debugging, running scripts from the command line, or connecting remotely without a browser.

---

## Step 7 — Do the exercises

Open any exercise file in VS Code (or Notepad), copy each block into the pgAdmin Query Tool, and run it with **F5**.  
Each file has guided examples followed by open challenges at the end — try to solve those on your own.

---

## Workshop Curriculum

Work through the files in order. Each session may not finish all of them — that's fine.  
The goal is hands-on practice, not speed.

| File | Topic | Key concepts |
|------|-------|-------------|
| `exercises/01_first_queries.sql` | **SELECT & DML basics** | SELECT, WHERE, ORDER BY, LIMIT, COUNT, INSERT, UPDATE |
| `exercises/02_ddl.sql` | **DDL — Define your schema** | CREATE TABLE, ALTER TABLE, DROP TABLE, constraints, CHECK |
| `exercises/03_views.sql` | **Views** | CREATE VIEW, updatable views, aggregate views, DROP VIEW |
| `exercises/04_indexes.sql` | **Indexes** | CREATE INDEX, EXPLAIN, EXPLAIN ANALYZE, composite indexes, UNIQUE |
| `exercises/05_functions.sql` | **Functions (PL/pgSQL)** | CREATE FUNCTION, DECLARE, IF/ELSIF, RETURNS TABLE, business logic |
| `exercises/06_procedures.sql` | **Stored Procedures** | CREATE PROCEDURE, CALL, OUT params, transactions, multi-step logic |
| `exercises/07_triggers.sql` | **Triggers** | BEFORE/AFTER INSERT/UPDATE, audit logs, business rule enforcement |

Solutions to the open challenges live in `exercises/solutions/`.

---

## The database

Three tables, 30 species, 23 named dinosaurs across all three eras.

```
eras ──< species ──< dinosaurs
```

| Table | What it stores |
|-------|---------------|
| `eras` | Triassic, Jurassic, Cretaceous — with time ranges in MYA |
| `species` | 30 species with diet, size, weight, discovery year |
| `dinosaurs` | Named individuals with enclosure and status (alive/sick/escaped/deceased) |

Notable residents: Rexy & Chomp (T-Rex), Blue/Delta/Echo (Velociraptors), Longneck (Diplodocus), Tiny (Archaeopteryx), Phantom (Coelophysis)

---

## Cheat sheet

| What you want | SQL |
|---|---|
| See all rows | `SELECT * FROM table_name;` |
| See specific columns | `SELECT col1, col2 FROM table_name;` |
| Filter rows | `... WHERE column = 'value'` |
| Sort results | `... ORDER BY column DESC` |
| Limit results | `... LIMIT 10` |
| Count rows | `SELECT COUNT(*) FROM table_name;` |
| Add a row | `INSERT INTO table_name (col1, col2) VALUES ('a', 'b');` |
| Change a row | `UPDATE table_name SET col1 = 'x' WHERE id = 1;` |
| Delete a row | `DELETE FROM table_name WHERE id = 1;` |

---

## Stop the database (when you're done)

```bash
docker compose down
```

Your data is saved in a Docker volume — it will still be there next time you run `docker compose up -d`.

---

## Troubleshooting

**Docker says "port 5432 already in use"**  
Another PostgreSQL is running. Stop it or change the port in `docker-compose.yml` from `5432:5432` to `5433:5432` (and use port 5433 in pgAdmin).

**pgAdmin can't connect to the server**  
Make sure you used `db` as the host (not `localhost`) — that's the container name Docker uses internally.

**`docker compose` command not found**  
Try `docker-compose` (with a hyphen) instead. Also make sure Docker Desktop is running and WSL integration is enabled.

**Containers stopped after restarting my PC**  
Just run `docker compose up -d` again from the workshop folder.
