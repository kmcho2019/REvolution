module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [3:0] and_result;
    wire [3:0] or_result;
    wire [3:0] xor_result;

    // Group 1: in[24:0]
    assign and_result[0] = &in[24:0];
    assign or_result[0] = |in[24:0];
    assign xor_result[0] = ^in[24:0];

    // Group 2: in[49:25]
    assign and_result[1] = &in[49:25];
    assign or_result[1] = |in[49:25];
    assign xor_result[1] = ^in[49:25];

    // Group 3: in[74:50]
    assign and_result[2] = &in[74:50];
    assign or_result[2] = |in[74:50];
    assign xor_result[2] = ^in[74:50];

    // Group 4: in[99:75]
    assign and_result[3] = &in[99:75];
    assign or_result[3] = |in[99:75];
    assign xor_result[3] = ^in[99:75];

    // Combine intermediate results
    assign out_and = &and_result;
    assign out_or = |or_result;
    assign out_xor = ^xor_result;

endmodule