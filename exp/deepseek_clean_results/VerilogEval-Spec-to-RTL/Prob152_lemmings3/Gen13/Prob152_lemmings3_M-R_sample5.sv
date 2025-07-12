module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // One-hot state encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;

    reg [2:0] state;
    reg direction; // 0=left, 1=right

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (1'b1) // synthesis parallel_case
                state[0]: // WALK
                    if (!ground)       state <= FALL;
                    else if (dig)      state <= DIG;
                    else              state <= WALK;
                
                state[1]: // FALL
                    if (ground)       state <= WALK;
                    else              state <= FALL;
                
                state[2]: // DIG
                    if (!ground)      state <= FALL;
                    else              state <= DIG;
            endcase
        end
    end

    // Direction logic (separate always block)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (state[0] && ground && !dig && (bump_left || bump_right)) begin
            direction <= bump_left ? 1'b1 : 1'b0;
        end
    end

    // Registered outputs
    always @(posedge clk) begin
        walk_left  <= state[0] & ~direction;
        walk_right <= state[0] & direction;
        aaah       <= state[1];
        digging    <= state[2];
    end

endmodule