module BitwiseOR(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out
);
    assign out = a | b;
endmodule

module LogicalOR(
    input [2:0] a,
    input [2:0] b,
    output out
);
    assign out = |a || |b;
endmodule

module VectorNOT(
    input [2:0] a,
    input [2:0] b,
    output [5:0] out
);
    assign out = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    
    // Instantiate Bitwise OR module
    BitwiseOR bit_or (
        .a(a),
        .b(b),
        .out(out_or_bitwise)
    );
    
    // Instantiate Logical OR module
    LogicalOR log_or (
        .a(a),
        .b(b),
        .out(out_or_logical)
    );
    
    // Instantiate Vector NOT module
    VectorNOT vec_not (
        .a(a),
        .b(b),
        .out(out_not)
    );

endmodule