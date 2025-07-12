module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire c0, c1, c2, c3;

    // Initial carry-in is zero
    assign c0 = 1'b0;

    // Bit 0 sum and carry
    assign sum[0] = x[0] ^ y[0] ^ c0;
    assign c1 = (x[0] & y[0]) | (x[0] & c0) | (y[0] & c0);

    // Bit 1 sum and carry
    assign sum[1] = x[1] ^ y[1] ^ c1;
    assign c2 = (x[1] & y[1]) | (x[1] & c1) | (y[1] & c1);

    // Bit 2 sum and carry
    assign sum[2] = x[2] ^ y[2] ^ c2;
    assign c3 = (x[2] & y[2]) | (x[2] & c2) | (y[2] & c2);

    // Bit 3 sum and carry-out
    assign sum[3] = x[3] ^ y[3] ^ c3;
    assign sum[4] = (x[3] & y[3]) | (x[3] & c3) | (y[3] & c3);
endmodule