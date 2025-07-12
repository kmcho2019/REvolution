module TopModule(
    input  [3:0] x,
    output       f
);

    // Decode x[2:3] into four distinct signals
    wire [3:0] decoded;
    assign decoded[0] = ~x[2] & ~x[3];  // x[2:3] = 00
    assign decoded[1] = ~x[2] & x[3];   // x[2:3] = 01
    assign decoded[2] = x[2] & ~x[3];   // x[2:3] = 10
    assign decoded[3] = x[2] & x[3];    // x[2:3] = 11

    // Logic for each decoded signal
    wire f_00;
    assign f_00 = (~x[0] & ~x[1]) | (x[0] & ~x[1]);  // Condition for x[2:3] = 00

    wire f_01;
    assign f_01 = 1'b0;  // Condition for x[2:3] = 01 is always 0

    wire f_10;
    assign f_10 = (~x[0] & ~x[1]) | (x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);  // Condition for x[2:3] = 10

    wire f_11;
    assign f_11 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]) | (x[0] & x[1]);  // Condition for x[2:3] = 11

    // Combine the conditions using the decoded signals
    assign f = (decoded[0] & f_00) | (decoded[1] & f_01) | (decoded[2] & f_10) | (decoded[3] & f_11);

endmodule