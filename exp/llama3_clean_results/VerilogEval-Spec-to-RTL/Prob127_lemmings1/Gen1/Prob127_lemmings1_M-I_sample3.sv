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

always_comb begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = current_state;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = current_state;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule