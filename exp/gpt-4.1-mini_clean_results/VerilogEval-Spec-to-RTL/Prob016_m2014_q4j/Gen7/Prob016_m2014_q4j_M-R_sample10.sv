module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;
    wire [3:0] axb;

    assign axb = x ^ y;
    // First bit sum and carry
    assign sum[0] = axb[0];
    assign carry[0] = x[0] & y[0];

    // Second bit
    assign sum[1] = axb[1] ^ carry[0];
    assign carry[1] = (x[1] & y[1]) | (axb[1] & carry[0]);

    // Third bit
    assign sum[2] = axb[2] ^ carry[1];
    assign carry[2] = (x[2] & y[2]) | (axb[2] & carry[1]);

    // Fourth bit
    assign sum[3] = axb[3] ^ carry[2];
    assign carry[3] = (x[3] & y[3]) | (axb[3] & carry[2]);

    // Overflow bit
    assign sum[4] = carry[3];
endmodule