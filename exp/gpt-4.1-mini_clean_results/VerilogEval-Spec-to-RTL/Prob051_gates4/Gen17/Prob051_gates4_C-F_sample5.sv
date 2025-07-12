module CombinedGates (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Efficient reduction operators for AND, OR, XOR
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule

module FourInputGate #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output       out
);
    // Instantiate shared CombinedGates to get all gate outputs at once
    wire out_and, out_or, out_xor;

    CombinedGates u_combined (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // Select output based on GATETYPE parameter
    assign out = (GATETYPE == "AND") ? out_and :
                 (GATETYPE == "OR")  ? out_or  :
                 (GATETYPE == "XOR") ? out_xor :
                 1'b0;  // default safe output
endmodule

module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Instantiate parameterized FourInputGate modules for each gate type
    FourInputGate #( .GATETYPE("AND") ) u_and ( .in(in), .out(out_and) );
    FourInputGate #( .GATETYPE("OR")  ) u_or  ( .in(in), .out(out_or) );
    FourInputGate #( .GATETYPE("XOR") ) u_xor ( .in(in), .out(out_xor) );

endmodule