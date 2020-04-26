# About
Database change automation and tracking using alembic, docker, and CI/CD*. This repo attempts to provide a step towards change control for database enviroments where change control is non existent or very open.
- *CI/CD not shown but works... in theory.


# How does it work?
 The Alembic tool offers an "on rails" change control experience. 
- Contributers can implement revisions that have a consistent upgrade and downgrade interface.
- Maintainer/DBA's with open ended systems can move users with CREATE/DROP/ALTER privilages down a route towards change control and review.

Docker abstracts away the enviroment/drivers/parameters needed to perform this change control and allow for an easy port between CI/CD implementations. The final flow should look like this:

1. Maintainer/DBA sets up docker-alembic on their CI/CD infrastructure.
2. Contributers create database changes as alembic migration files / revisions 
3. When a contributer's database changes are approved and the pr is merged the database/alembic will keep track of the revision state and get up to date.


## What is this for?
- A low friction example of change control (CR) process and automation for a database.
- Logging of changes and a chance to socialize/discuss why a change to is needed.

## What is **this not** for?
- Data entry or CRUD operations.
- Best practices on bootstrapping an application or analytical framework.
    - This is more gap coverage for the manual work.
- Managing lots of decoupled workflows
    - One downgrade may undo other changes.
- Not a great example of using the SQLAlchemy Database Toolkit to it's full extent.
  - This is more of a framework to house scripts.

## Requirements
- docker
- github

# Quickstart
To get a feel for how this flow would work we will use a small sqllite instance. 
> **Note** that the `$pwd\` is a windows powershell convention.

1. Clone the repo.
1. Build your docker image.
    - ```docker build -t docker-alembic:0.0.1 .```
1. Create a revision for your project
    - `docker run --rm -v $pwd\docker-alembic_project:/app/docker-alembic_project:rw docker-alembic:0.0.1 revision -m "my_cool_revision"`
1. Open the <hash>_my_cool_revision.py file and replace the `upgrade` and `downgrade` functions with the following.
    - ```
        def upgrade():
            op.execute('CREATE TABLE foo (field1 string,field2 string);')
            op.execute("INSERT INTO foo VALUES('hello','world');")

        def downgrade():
            op.execute('DROP TABLE foo;')
        ```
1. Apply the changes.
    - `docker run --rm -v $pwd\docker-alembic_project:/app/docker-alembic_project:rw docker-alembic:0.0.1 upgrade head`
1. View interactively in sqlite3 cli.
    - `docker run --rm -it -v $pwd\docker-alembic_project:/app/docker-alembic_project:rw --entrypoint sqlite3 docker-alembic:0.0.1 mock_db/mock.db "select * from foo;"` 
1. Downgrade your changes.
    - `docker run --rm -v $pwd\docker-alembic_project:/app/docker-alembic_project:rw docker-alembic:0.0.1 downgrade base`

## Next steps:
- See if there is a [Sql Alchemy Dialect](https://docs.sqlalchemy.org/en/13/dialects/index.html) available for your system.
- Work this into your CI/CD pipeline.
- Utilize some of the alembic [migration directives](https://alembic.sqlalchemy.org/en/latest/ops.html#ops) or build your own to keep the changes DRY and less scripty.

# How to implement as a maintaner /DBA
- Ensure that at least a sqlalchemy dilect exists/works on your system.
- Determine if multiple projects are needed for your enviroment.
    - This helps avoid the complexity with decoupled downgrades affecting each other.
    - If not have the revisions commited as soon as they are pushed to prevent multiple heads while Alembic does support [branches](https://alembic.sqlalchemy.org/en/latest/branches.html) they can be a bit confusing.
- Have a service account setup securely to run on your CI/CD pipeline and source control method.
