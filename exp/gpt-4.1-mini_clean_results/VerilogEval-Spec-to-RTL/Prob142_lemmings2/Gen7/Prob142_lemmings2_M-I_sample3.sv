module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding:
    // bit1 = falling flag (1 = falling, 0 = walking)
    // bit0 = direction (0 = left, 1 = right)
    // 2'b00 = walking left
    // 2'b01 = walking right
    // 2'b10 = falling left
    // 2'b11 = falling right
    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            2'b00: begin // walking left
                if (!ground)
                    next_state = 2'b10; // fall left
                else if (bump_left && bump_right)
                    next_state = 2'b01; // flip direction to right
                else if (bump_left)
                    next_state = 2'b01; // walk right
                else if (bump_right)
                    next_state = 2'b00; // stay walking left (or redundant)
                else
                    next_state = 2'b00;
            end
            2'b01: begin // walking right
                if (!ground)
                    next_state = 2'b11; // fall right
                else if (bump_left && bump_right)
                    next_state = 2'b00; // flip direction to left
                else if (bump_left)
                    next_state = 2'b01; // stay walking right
                else if (bump_right)
                    next_state = 2'b00; // walk left
                else
                    next_state = 2'b01;
            end
            2'b10: begin // falling left
                if (ground)
                    next_state = 2'b00; // resume walking left
                else
                    next_state = 2'b10; // keep falling left
            end
            2'b11: begin // falling right
                if (ground)
                    next_state = 2'b01; // resume walking right
                else
                    next_state = 2'b11; // keep falling right
            end
            default: next_state = 2'b00;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walking left
        else
            state <= next_state;
    end

    // Outputs
    assign aaah       = state[1];           // falling flag
    assign walk_left  = (state[1] == 1'b0) && (state[0] == 1'b0);
    assign walk_right = (state[1] == 1'b0) && (state[0] == 1'b1);

endmodule