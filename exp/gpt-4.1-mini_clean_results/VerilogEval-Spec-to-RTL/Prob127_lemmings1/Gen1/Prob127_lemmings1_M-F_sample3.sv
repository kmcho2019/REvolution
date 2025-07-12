module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left  <= 1'b1;  // Outputs set on reset
            walk_right <= 1'b0;
        end else begin
            state <= next_state;
            // Update outputs synchronously with state
            walk_left  <= (next_state == WALK_LEFT);
            walk_right <= (next_state == WALK_RIGHT);
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

endmodule