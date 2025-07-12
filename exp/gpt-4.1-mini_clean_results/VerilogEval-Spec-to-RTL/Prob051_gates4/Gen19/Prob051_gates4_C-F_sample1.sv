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
            or  u0(level1_0, in[0], in[1]);
            or  u1(level1_1, in[2], in[3]);
            or  u2(out,     level1_0, level1_1);
        end else begin
            assign out = 1'b0; // safe fallback for unsupported gate type
        end
    endgenerate
endmodule

// Balanced 4-input 2-input XOR gate tree module
module FourInputXor (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;
    xor u0(level1_0, in[0], in[1]);
    xor u1(level1_1, in[2], in[3]);
    xor u2(out,     level1_0, level1_1);
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate balanced AND gate tree
    FourInputAndOr #(.GATETYPE("AND")) u_and (.in(in), .out(out_and));

    // Instantiate balanced OR gate tree
    FourInputAndOr #(.GATETYPE("OR"))  u_or  (.in(in), .out(out_or));

    // Instantiate balanced XOR gate tree
    FourInputXor                     u_xor (.in(in), .out(out_xor));

endmodule