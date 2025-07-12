module UnaryOp #(
    parameter OP_NOT = 1'b1
)(
    input  wire in,
    output wire out
);
    // Generate the output based on the parameter OP_NOT
    assign out = OP_NOT ? ~in : in;  // Only NOT operation implemented; else passes input through
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    // Instantiate UnaryOp with NOT operation enabled
    UnaryOp #(.OP_NOT(1'b1)) u_unaryop (
        .in(in),
        .out(out)
    );
endmodule