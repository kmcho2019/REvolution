module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [3:0] and_results;
    wire [3:0] or_results;
    wire [3:0] xor_results;

    // Perform operations in chunks of 25 bits
    assign and_results[0] = &in[24:0];
    assign and_results[1] = &in[49:25];
    assign and_results[2] = &in[74:50];
    assign and_results[3] = &in[99:75];

    assign or_results[0] = |in[24:0];
    assign or_results[1] = |in[49:25];
    assign or_results[2] = |in[74:50];
    assign or_results[3] = |in[99:75];

    assign xor_results[0] = ^in[24:0];
    assign xor_results[1] = ^in[49:25];
    assign xor_results[2] = ^in[74:50];
    assign xor_results[3] = ^in[99:75];

    // Combine chunk results
    assign out_and = &and_results;
    assign out_or = |or_results;
    assign out_xor = ^xor_results;

endmodule