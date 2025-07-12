module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation
    wire [2:0] Y;
    assign Y[0] = (y == 3'b000 & x) |                 // 000->001 when x=1
                  (y == 3'b001 & ~x) |                // 001->001 when x=0
                  (y == 3'b010 & x) |                 // 010->001 when x=1
                  (y == 3'b011 & ~x) |                // 011->001 when x=0
                  (y == 3'b100 & ~x);                // 100->011 when x=0

    assign Y[1] = (y == 3'b010 & ~x) |                // 010->010 when x=0
                  (y == 3'b011 & x) |                 // 011->010 when x=1
                  (y == 3'b100 & ~x);                // 100->011 when x=0

    assign Y[2] = (y == 3'b001 & x) |                 // 001->100 when x=1
                  (y == 3'b100 & x);                 // 100->100 when x=1

    // Output computation
    assign z = (y == 3'b011) | (y == 3'b100);

    assign Y0 = Y[0];

endmodule