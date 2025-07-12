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

    // State encoding: 2 bits
    // 2'b00: walk left
    // 2'b01: walk right
    // 2'b10: falling
    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            2'b00: begin // walking left
                if (!ground)
                    next_state = 2'b10; // falling
                else if (bump_left || bump_right)
                    next_state = 2'b01; // walk right
                else
                    next_state = 2'b00; // stay walking left
            end
            2'b01: begin // walking right
                if (!ground)
                    next_state = 2'b10; // falling
                else if (bump_left || bump_right)
                    next_state = 2'b00; // walk left
                else
                    next_state = 2'b01; // stay walking right
            end
            2'b10: begin // falling
                if (ground)
                    // Resume walking in previous direction stored in state[0]
                    // We keep the walking direction bit from before falling:
                    // If state[0] == 0 => walk left; else walk right
                    next_state = {1'b0, state[0]};
                else
                    next_state = 2'b10; // continue falling
            end
            default: next_state = 2'b00; // default to walk left
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left on reset
        else
            state <= next_state;
    end

    // Output decoding - Moore outputs depend on current state
    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = (state == 2'b10);

endmodule