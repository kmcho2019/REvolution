module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] carry; // carry[0] = 0 initial carry-in

    assign carry[0] = 1'b0;

    // Bit 0 full adder
    assign sum[0] = x[0] ^ y[0] ^ carry[0];
    assign carry[1] = (x[0] & y[0]) | (x[0] & carry[0]) | (y[0] & carry[0]);

    // Bit 1 full adder
    assign sum[1] = x[1] ^ y[1] ^ carry[1];
    assign carry[2] = (x[1] & y[1]) | (x[1] & carry[1]) | (y[1] & carry[1]);

    // Bit 2 full adder
    assign sum[2] = x[2] ^ y[2] ^ carry[2];
    assign carry[3] = (x[2] & y[2]) | (x[2] & carry[2]) | (y[2] & carry[2]);

    // Bit 3 full adder
    assign sum[3] = x[3] ^ y[3] ^ carry[3];
    assign carry[4] = (x[3] & y[3]) | (x[3] & carry[3]) | (y[3] & carry[3]);

    assign sum[4] = carry[4]; // overflow bit
endmodule