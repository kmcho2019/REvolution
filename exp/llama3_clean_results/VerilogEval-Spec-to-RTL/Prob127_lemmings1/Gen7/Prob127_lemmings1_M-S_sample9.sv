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
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_left) begin
                    current_state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else begin
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    current_state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
            default: begin
                current_state <= WALK_LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        endcase
    end
end

endmodule