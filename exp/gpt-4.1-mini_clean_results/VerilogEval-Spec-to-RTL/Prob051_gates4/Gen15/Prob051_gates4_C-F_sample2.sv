// Parameterized module implementing a balanced tree of 2-input AND or OR gates
module FourInputAndOr #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;

    generate
        if (GATETYPE == "AND") begin
            and u0(level1_0, in[0], in[1]);
            and u1(level1_1, in[2], in[3]);
            and u2(out,     level1_0, level1_1);
        end else if (GATETYPE == "OR") begin
            or u0(level1_0, in[0], in[1]);
            or u1(level1_1, in[2], in[3]);
            or u2(out,     level1_0, level1_1);
        end else begin
            assign out = 1'b0; // default safe fallback
        end
    endgenerate
endmodule

module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Explicit balanced AND tree
    FourInputAndOr #(.GATETYPE("AND")) u_and (.in(in), .out(out_and));
    // Explicit balanced OR tree
    FourInputAndOr #(.GATETYPE("OR"))  u_or  (.in(in), .out(out_or));
    // Direct reduction XOR operator for succinct and efficient logic
    assign out_xor = ^in;

endmodule