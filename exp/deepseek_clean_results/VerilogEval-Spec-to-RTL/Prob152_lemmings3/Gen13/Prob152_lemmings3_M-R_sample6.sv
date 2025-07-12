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

    // One-hot states with direction (bit0=left, bit1=right)
    reg [3:0] state;
    parameter WALK_LEFT  = 4'b0001;
    parameter WALK_RIGHT = 4'b0010;
    parameter FALL       = 4'b0100;
    parameter DIG        = 4'b1000;

    // Next state logic with explicit priority (fall > dig > bump)
    wire [3:0] next_state = 
        (!ground && (state == WALK_LEFT || state == WALK_RIGHT || state == DIG)) ? FALL :
        (ground && state == FALL) ? (state[0] ? WALK_LEFT : WALK_RIGHT) :
        (dig && ground && (state == WALK_LEFT || state == WALK_RIGHT)) ? DIG :
        (state == DIG && !ground) ? FALL :
        (state == WALK_LEFT && bump_left) ? WALK_RIGHT :
        (state == WALK_RIGHT && bump_right) ? WALK_LEFT :
        state;

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else state <= next_state;
    end

    // Output assignments
    assign walk_left  = state == WALK_LEFT;
    assign walk_right = state == WALK_RIGHT;
    assign aaah       = state == FALL;
    assign digging    = state == DIG;

endmodule