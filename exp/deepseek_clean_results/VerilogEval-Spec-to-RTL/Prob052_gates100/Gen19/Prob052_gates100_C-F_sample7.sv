module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 5 segments of 20 bits each for balanced tree reduction
    assign out_and = &{ &in[99:80], &in[79:60], &in[59:40], &in[39:20], &in[19:0] };
    assign out_or  = |{ |in[99:80], |in[79:60], |in[59:40], |in[39:20], |in[19:0] };
    
    // Use direct reduction for XOR (most efficient implementation)
    assign out_xor = ^in;

endmodule