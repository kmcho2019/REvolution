module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation using bitwise operations
    wire [2:0] next_state;
    assign next_state[2] = (~y[2] & ~y[1] & y[0] & x) |  // 001 -> 100 when x=1
                          (y[2] & ~y[1] & ~y[0] & x);    // 100 -> 100 when x=1
    
    assign next_state[1] = (~y[2] & y[1] & ~y[0] & ~x) | // 010 -> 010 when x=0
                          (~y[2] & y[1] & y[0] & ~x) |   // 011 -> 001 when x=0
                          (y[2] & ~y[1] & ~y[0] & ~x) |  // 100 -> 011 when x=0
                          (~y[2] & y[1] & y[0] & x);     // 011 -> 010 when x=1
    
    assign next_state[0] = (~y[2] & ~y[1] & ~y[0] & x) | // 000 -> 001 when x=1
                          (~y[2] & ~y[1] & y[0] & ~x) |  // 001 -> 001 when x=0
                          (~y[2] & y[1] & ~y[0] & x) |   // 010 -> 001 when x=1
                          (~y[2] & y[1] & y[0] & ~x) |   // 011 -> 001 when x=0
                          (y[2] & ~y[1] & ~y[0] & ~x);   // 100 -> 011 when x=0

    // Output logic
    assign z = (y == 3'b011) | (y == 3'b100);
    assign Y0 = next_state[0];

endmodule