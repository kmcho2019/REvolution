module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire c0, c1, c2, c3;

    // First bit addition
    assign sum[0] = x[0] ^ y[0];             // sum bit 0 with carry-in 0
    assign c0     = x[0] & y[0];             // carry-out bit 0

    // Second bit addition
    assign sum[1] = x[1] ^ y[1] ^ c0;
    assign c1     = (x[1] & y[1]) | (x[1] & c0) | (y[1] & c0);

    // Third bit addition
    assign sum[2] = x[2] ^ y[2] ^ c1;
    assign c2     = (x[2] & y[2]) | (x[2] & c1) | (y[2] & c1);

    // Fourth bit addition
    assign sum[3] = x[3] ^ y[3] ^ c2;
    assign c3     = (x[3] & y[3]) | (x[3] & c2) | (y[3] & c2);

    // Final carry as overflow bit
    assign sum[4] = c3;
endmodule