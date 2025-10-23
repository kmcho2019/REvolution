module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Combined state encoding [1:0]:
    // [1] - 0=WALK, 1=FALL
    // [0] - direction (0=left, 1=right)
    reg [1:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // WALK left
        end
        else begin
            case (state[1])
                0: // WALK
                    if (!ground) begin
                        state <= {1'b1, state[0]}; // FALL same direction
                    end
                    else if (dig) begin
                        // Stay in WALK state, keep direction
                    end
                    else if (bump_left || bump_right) begin
                        state[0] <= bump_left; // Change direction
                    end
                
                1: // FALL
                    if (ground) begin
                        state <= {1'b0, state[0]}; // WALK same direction
                    end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = state[1];
    assign digging    = (~state[1] & dig & ground);

endmodule