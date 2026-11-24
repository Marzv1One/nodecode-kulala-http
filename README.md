# kulala-http

A Nodecode cell containing a portable `kulala-http` skill for writing and validating Kulala.nvim/kulala-core `.http` requests and `http-client.env.json` environments.

The skill lives in [`skills/kulala-http/SKILL.md`](skills/kulala-http/SKILL.md). Its frontmatter makes it available to Nodecode's skill index; read it with `(help 'kulala-http)`. Index inclusion and automatic selection are ranked and budgeted, so explicitly request the skill when its use matters. When delegating a task, tell the worker to read and follow the skill; workers should not be assumed to inherit the parent's conversation.

This cell is listed in `/cells` and has its own Git repository. It defines guidance, not a slash command or a background job. The skill is self-contained and may also be copied to a compatible agent's skills directory, subject to that agent's discovery rules.

The skill includes a safe loopback mock example and documents verified version-specific behavior. Review the current Kulala documentation and test with the installed version; do not run real or destructive requests without appropriate authorization.
