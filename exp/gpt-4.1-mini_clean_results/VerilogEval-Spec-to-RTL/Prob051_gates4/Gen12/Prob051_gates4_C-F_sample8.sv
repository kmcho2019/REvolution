// Parameterized 4-input gate module using 2-input gates in a balanced tree
module FourInputGate #(parameter GATETYPE = "AND") (
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
        end else if (GATETYPE == "XOR") begin
            xor u0(level1_0, in[0], in[1]);
            xor u1(level1_1, in[2], in[3]);
            xor u2(out,     level1_0, level1_1);
        end else begin
            // Default: tie output to 0 for unsupported gate types
            assign out = 1'b0;
        end
    endgenerate
endmodule

module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Instantiate reusable parameterized 4-input gate modules for each output
    FourInputGate #( .GATETYPE("AND") ) u_and ( .in(in), .out(out_and) );
    FourInputGate #( .GATETYPE("OR")  ) u_or  ( .in(in), .out(out_or) );
    FourInputGate #( .GATETYPE("XOR") ) u_xor ( .in(in), .out(out_xor) );

endmodule