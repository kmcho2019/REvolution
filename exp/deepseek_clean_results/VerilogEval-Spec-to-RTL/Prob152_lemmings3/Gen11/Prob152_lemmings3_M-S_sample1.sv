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

    // States
    reg [1:0] state;
    reg direction; // 0=left, 1=right

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;
            direction <= 0;
        end
        else case (state)
            0: // WALK
                if (!ground)      state <= 1;
                else if (dig)     state <= 2;
                else              direction <= bump_left ? 1 : (bump_right ? 0 : direction);
            
            1: // FALL
                if (ground) state <= 0;
            
            2: // DIG
                if (!ground) state <= 1;
        endcase
    end

    // Output logic
    assign walk_left  = (state == 0) & ~direction;
    assign walk_right = (state == 0) & direction;
    assign aaah       = (state == 1);
    assign digging    = (state == 2);

endmodule