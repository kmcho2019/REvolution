module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 5 slices of 20 bits each
    wire [4:0] slice_and;
    wire [4:0] slice_or;
    wire [4:0] slice_xor;

    assign slice_and[0] = &in[19:0];
    assign slice_and[1] = &in[39:20];
    assign slice_and[2] = &in[59:40];
    assign slice_and[3] = &in[79:60];
    assign slice_and[4] = &in[99:80];

    assign slice_or[0] = |in[19:0];
    assign slice_or[1] = |in[39:20];
    assign slice_or[2] = |in[59:40];
    assign slice_or[3] = |in[79:60];
    assign slice_or[4] = |in[99:80];

    assign slice_xor[0] = ^in[19:0];
    assign slice_xor[1] = ^in[39:20];
    assign slice_xor[2] = ^in[59:40];
    assign slice_xor[3] = ^in[79:60];
    assign slice_xor[4] = ^in[99:80];

    // Second stage: Combine slice results
    assign out_and = &slice_and;
    assign out_or = |slice_or;
    assign out_xor = ^slice_xor;

endmodule