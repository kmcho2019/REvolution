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
    parameter WALK_L = 3'b001;
    parameter WALK_R = 3'b010;
    parameter FALL   = 3'b100;
    parameter DIG_L  = 3'b101;
    parameter DIG_R  = 3'b110;

    reg [2:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end
        else case (state)
            WALK_L: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG_L;
                else if (bump_left) state <= WALK_R;
            end
            
            WALK_R: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG_R;
                else if (bump_right) state <= WALK_L;
            end
            
            FALL: if (ground) begin
                if (state[0]) state <= WALK_L; // Last bit indicates direction
                else state <= WALK_R;
            end
            
            DIG_L: if (!ground) state <= FALL;
            DIG_R: if (!ground) state <= FALL;
        endcase
    end

    // Output logic - simplified with one-hot
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL);
    assign digging    = (state[2] & ~state[1]); // DIG_L or DIG_R

endmodule