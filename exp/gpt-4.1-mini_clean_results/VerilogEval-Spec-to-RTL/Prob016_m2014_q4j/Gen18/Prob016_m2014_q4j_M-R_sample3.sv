module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;

    // bit 0 full adder
    assign sum[0] = x[0] ^ y[0];
    assign carry[0] = x[0] & y[0];

    // bit 1 full adder
    assign sum[1] = x[1] ^ y[1] ^ carry[0];
    assign carry[1] = (x[1] & y[1]) | (carry[0] & (x[1] ^ y[1]));

    // bit 2 full adder
    assign sum[2] = x[2] ^ y[2] ^ carry[1];
    assign carry[2] = (x[2] & y[2]) | (carry[1] & (x[2] ^ y[2]));

    // bit 3 full adder
    assign sum[3] = x[3] ^ y[3] ^ carry[2];
    assign carry[3] = (x[3] & y[3]) | (carry[2] & (x[3] ^ y[3]));

    // overflow bit (final carry out)
    assign sum[4] = carry[3];

endmodule