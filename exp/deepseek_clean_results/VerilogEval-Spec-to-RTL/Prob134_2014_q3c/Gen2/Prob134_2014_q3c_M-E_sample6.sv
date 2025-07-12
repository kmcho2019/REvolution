module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic using parallel bit equations
    wire [2:0] Y;
    assign Y[0] = (~x & (y == 3'b000)) |                 // Y0 when x=0, state 000
                  (~x & (y == 3'b001)) |                 // Y0 when x=0, state 001
                  (~x & (y == 3'b010)) |                 // Y0 when x=0, state 010
                  (~x & (y == 3'b011)) |                 // Y0 when x=0, state 011
                  (x & (y == 3'b000)) |                  // Y0 when x=1, state 000
                  (x & (y == 3'b010)) |                  // Y0 when x=1, state 010
                  (x & (y == 3'b011)) |                  // Y0 when x=1, state 011
                  (~x & (y == 3'b100));                  // Y0 when x=0, state 100

    assign Y[1] = (~x & (y == 3'b010)) |                 // Y1 when x=0, state 010
                  (x & (y == 3'b011)) |                  // Y1 when x=1, state 011
                  (~x & (y == 3'b100));                  // Y1 when x=0, state 100

    assign Y[2] = (x & (y == 3'b001)) |                  // Y2 when x=1, state 001
                  (x & (y == 3'b100));                  // Y2 when x=1, state 100

    // Output logic - z is high only in states 011 and 100
    assign z = (y[2] & ~y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

    // Y0 is the LSB of next state
    assign Y0 = Y[0];

endmodule