module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
state_t current_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_left) begin
                    current_state <= WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    current_state <= WALK_LEFT;
                end
            end
            default: current_state <= WALK_LEFT;
        endcase
    end
end

assign walk_left = (current_state == WALK_LEFT);
assign walk_right = (current_state == WALK_RIGHT);

endmodule