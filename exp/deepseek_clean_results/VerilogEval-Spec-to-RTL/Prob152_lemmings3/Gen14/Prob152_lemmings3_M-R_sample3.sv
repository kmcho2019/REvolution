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
                    if (!ground)      state <= FALL;
                    else if (dig)     state <= DIG;
                    else              state <= WALK;
                
                state[1]: // FALL
                    if (ground)       state <= WALK;
                    else             state <= FALL;
                
                state[2]: // DIG
                    if (!ground)      state <= FALL;
                    else              state <= DIG;
            endcase
        end
    end

    // Direction tracking
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (state == WALK && ground && !dig) begin
            if (bump_left)      direction <= 1;
            else if (bump_right) direction <= 0;
        end
    end

    // Output assignments
    assign walk_left  = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule