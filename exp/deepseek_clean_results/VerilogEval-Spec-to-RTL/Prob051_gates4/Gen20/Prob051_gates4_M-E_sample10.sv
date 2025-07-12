module NInputAND #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output out
);
    assign out = &in;
endmodule

module NInputOR #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output out
);
    assign out = |in;
endmodule

module NInputXOR #(parameter WIDTH = 4) (
    input [WIDTH-1:0] in,
    output out
);
    assign out = ^in;
endmodule

module TopModule (
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    NInputAND and_gate (.in(in), .out(out_and));
    NInputOR  or_gate  (.in(in), .out(out_or));
    NInputXOR xor_gate (.in(in), .out(out_xor));

endmodule