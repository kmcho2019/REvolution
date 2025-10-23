module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
state_t current_state, next_state;

assign next_state = (current_state == WALK_LEFT) ? (bump_left ? WALK_RIGHT : WALK_LEFT) : (bump_right ? WALK_LEFT : WALK_RIGHT);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

assign walk_left = (current_state == WALK_LEFT);
assign walk_right = (current_state == WALK_RIGHT);

endmodule