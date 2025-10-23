module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;
    wire [3:0] s;

    // First bit addition
    assign s[0] = x[0] ^ y[0];
    assign carry[0] = x[0] & y[0];

    // Second bit addition
    assign s[1] = x[1] ^ y[1] ^ carry[0];
    assign carry[1] = (x[1] & y[1]) | (x[1] & carry[0]) | (y[1] & carry[0]);

    // Third bit addition
    assign s[2] = x[2] ^ y[2] ^ carry[1];
    assign carry[2] = (x[2] & y[2]) | (x[2] & carry[1]) | (y[2] & carry[1]);

    // Fourth bit addition
    assign s[3] = x[3] ^ y[3] ^ carry[2];
    assign carry[3] = (x[3] & y[3]) | (x[3] & carry[2]) | (y[3] & carry[2]);

    // Assign sum output bits
    assign sum[3:0] = s;
    assign sum[4] = carry[3]; // final carry out as overflow bit
endmodule