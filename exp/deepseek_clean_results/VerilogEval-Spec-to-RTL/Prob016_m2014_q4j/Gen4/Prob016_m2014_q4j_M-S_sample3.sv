module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire carry0, carry1, carry2;

    // Bit 0
    assign sum[0] = x[0] ^ y[0];
    assign carry0 = x[0] & y[0];

    // Bit 1
    assign sum[1] = x[1] ^ y[1] ^ carry0;
    assign carry1 = (x[1] & y[1]) | (x[1] & carry0) | (y[1] & carry0);

    // Bit 2
    assign sum[2] = x[2] ^ y[2] ^ carry1;
    assign carry2 = (x[2] & y[2]) | (x[2] & carry1) | (y[2] & carry1);

    // Bit 3
    assign sum[3] = x[3] ^ y[3] ^ carry2;
    assign sum[4] = (x[3] & y[3]) | (x[3] & carry2) | (y[3] & carry2);
endmodule