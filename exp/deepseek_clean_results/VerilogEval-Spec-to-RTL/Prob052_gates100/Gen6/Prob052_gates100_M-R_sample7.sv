module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Combined hierarchical reduction in single expressions
    assign out_and = &{ &in[9:0],   &in[19:10],  &in[29:20],  &in[39:30],
                       &in[49:40],  &in[59:50],  &in[69:60],  &in[79:70],
                       &in[89:80],  &in[99:90] };

    assign out_or  = |{ |in[9:0],   |in[19:10],  |in[29:20],  |in[39:30],
                       |in[49:40],  |in[59:50],  |in[69:60],  |in[79:70],
                       |in[89:80],  |in[99:90] };

    assign out_xor = ^{ ^in[9:0],   ^in[19:10],  ^in[29:20],  ^in[39:30],
                       ^in[49:40],  ^in[59:50],  ^in[69:60],  ^in[79:70],
                       ^in[89:80],  ^in[99:90] };

endmodule