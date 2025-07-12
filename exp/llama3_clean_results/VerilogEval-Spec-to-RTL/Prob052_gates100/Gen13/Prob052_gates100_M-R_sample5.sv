module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [9:0] seg_and;
    wire [9:0] seg_or;
    wire [9:0] seg_xor;

    // Segment 0
    assign seg_and[0] = &(in[9:0]);
    assign seg_or[0] = |(in[9:0]);
    assign seg_xor[0] = ^(in[9:0]);

    // Segment 1
    assign seg_and[1] = &(in[19:10]);
    assign seg_or[1] = |(in[19:10]);
    assign seg_xor[1] = ^(in[19:10]);

    // Segment 2
    assign seg_and[2] = &(in[29:20]);
    assign seg_or[2] = |(in[29:20]);
    assign seg_xor[2] = ^(in[29:20]);

    // Segment 3
    assign seg_and[3] = &(in[39:30]);
    assign seg_or[3] = |(in[39:30]);
    assign seg_xor[3] = ^(in[39:30]);

    // Segment 4
    assign seg_and[4] = &(in[49:40]);
    assign seg_or[4] = |(in[49:40]);
    assign seg_xor[4] = ^(in[49:40]);

    // Segment 5
    assign seg_and[5] = &(in[59:50]);
    assign seg_or[5] = |(in[59:50]);
    assign seg_xor[5] = ^(in[59:50]);

    // Segment 6
    assign seg_and[6] = &(in[69:60]);
    assign seg_or[6] = |(in[69:60]);
    assign seg_xor[6] = ^(in[69:60]);

    // Segment 7
    assign seg_and[7] = &(in[79:70]);
    assign seg_or[7] = |(in[79:70]);
    assign seg_xor[7] = ^(in[79:70]);

    // Segment 8
    assign seg_and[8] = &(in[89:80]);
    assign seg_or[8] = |(in[89:80]);
    assign seg_xor[8] = ^(in[89:80]);

    // Segment 9
    assign seg_and[9] = &(in[99:90]);
    assign seg_or[9] = |(in[99:90]);
    assign seg_xor[9] = ^(in[99:90]);

    assign out_and = &(seg_and);
    assign out_or = |(seg_or);
    assign out_xor = ^(seg_xor);

endmodule