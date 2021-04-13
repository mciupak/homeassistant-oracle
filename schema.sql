CREATE TABLE ha.events (
	event_id NUMBER GENERATED ALWAYS AS IDENTITY,
	event_type VARCHAR(32),
	event_data CLOB,
	origin VARCHAR(32),
	time_fired DATE,
	created DATE,
	context_id VARCHAR(36),
	context_user_id VARCHAR(36), context_parent_id CHARACTER(36),
	PRIMARY KEY (event_id)
);
CREATE TABLE ha.recorder_runs (
	run_id NUMBER GENERATED ALWAYS AS IDENTITY,
	"start" DATE,
	end DATE,
	closed_incorrect NUMBER,
	created DATE,
	PRIMARY KEY (run_id),
	CHECK (closed_incorrect IN (0, 1))
);
CREATE TABLE ha.schema_changes (
	change_id NUMBER GENERATED ALWAYS AS IDENTITY,
	schema_version NUMBER,
	changed DATE,
	PRIMARY KEY (change_id)
);
CREATE TABLE ha.states (
	state_id NUMBER GENERATED ALWAYS AS IDENTITY,
	domain VARCHAR(64),
	entity_id VARCHAR(255),
	state VARCHAR(255),
	attributes CLOB,
	event_id NUMBER,
	last_changed DATE,
	last_updated DATE,
	created DATE,
	context_id VARCHAR(36),
	context_user_id VARCHAR(36), context_parent_id CHARACTER(36), old_state_id NUMBER,
	PRIMARY KEY (state_id),
	FOREIGN KEY(event_id) REFERENCES ha.events (event_id)
);

CREATE INDEX ha.ix_events_context_user_id ON ha.events (context_user_id);
CREATE INDEX ha.ix_events_event_type ON ha.events (event_type);
CREATE INDEX ha.ix_events_context_id ON ha.events (context_id);
CREATE INDEX ha.ix_events_time_fired ON ha.events (time_fired);
CREATE INDEX ha.ix_recorder_runs_start_end ON ha.recorder_runs (start, "end");
CREATE INDEX ha.ix_states_entity_id ON ha.states (entity_id);
CREATE INDEX ha.ix_states_context_user_id ON ha.states (context_user_id);
CREATE INDEX ha.ix_states_last_updated ON ha.states (last_updated);
CREATE INDEX ha.ix_states_event_id ON ha.states (event_id);
CREATE INDEX ha.ix_states_entity_id_last_updated ON ha.states (entity_id, last_updated);
CREATE INDEX ha.ix_states_context_id ON ha.states (context_id);
CREATE INDEX ha.ix_states_context_parent_id ON ha.states (context_parent_id);
CREATE INDEX ha.ix_events_context_parent_id ON ha.events (context_parent_id);
