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

    // State encoding:
    // state[0]: 0=left, 1=right
    // state[1]: 0=walking, 1=digging
    // 2'b00: walk left
    // 2'b01: walk right
    // 2'b10: dig left
    // 2'b11: dig right
    parameter FALL = 1'b1;
    
    reg [1:0] state;
    reg falling;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // walk left
            falling <= 1'b0;
        end
        else if (falling) begin
            if (ground) begin
                falling <= 1'b0;
                // Keep original direction but clear dig state
                state <= {1'b0, state[0]};
            end
        end
        else begin // not falling
            if (!ground) begin
                falling <= 1'b1;
            end
            else if (dig) begin
                state <= {1'b1, state[0]}; // set dig bit, keep direction
            end
            else if (bump_left || bump_right) begin
                state <= {1'b0, bump_left}; // clear dig bit, set direction
            end
        end
    end

    // Output logic - purely combinatorial
    assign walk_left  = ~falling & ~state[1] & ~state[0];
    assign walk_right = ~falling & ~state[1] & state[0];
    assign aaah       = falling;
    assign digging    = ~falling & state[1];
endmodule