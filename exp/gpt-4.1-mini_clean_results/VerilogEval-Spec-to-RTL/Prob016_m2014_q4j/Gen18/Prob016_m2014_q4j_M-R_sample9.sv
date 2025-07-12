module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;
    wire [3:0] axb;

    // Bit 0
    assign axb[0] = x[0] ^ y[0];
    assign sum[0] = axb[0];
    assign carry[0] = x[0] & y[0];

    // Bit 1
    assign axb[1] = x[1] ^ y[1];
    assign sum[1] = axb[1] ^ carry[0];
    assign carry[1] = (x[1] & y[1]) | (axb[1] & carry[0]);

    // Bit 2
    assign axb[2] = x[2] ^ y[2];
    assign sum[2] = axb[2] ^ carry[1];
    assign carry[2] = (x[2] & y[2]) | (axb[2] & carry[1]);

    // Bit 3
    assign axb[3] = x[3] ^ y[3];
    assign sum[3] = axb[3] ^ carry[2];
    assign carry[3] = (x[3] & y[3]) | (axb[3] & carry[2]);

    // Final carry-out as MSB of sum
    assign sum[4] = carry[3];
endmodule