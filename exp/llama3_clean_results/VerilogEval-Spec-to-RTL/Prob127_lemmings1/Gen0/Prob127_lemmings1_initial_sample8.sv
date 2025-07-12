module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} current_state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_left) begin
                    current_state <= WALK_RIGHT;
                end else begin
                    current_state <= current_state;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    current_state <= WALK_LEFT;
                end else begin
                    current_state <= current_state;
                end
            end
            default: begin
                current_state <= WALK_LEFT;
            end
        endcase
    end
end

// Combinational logic
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