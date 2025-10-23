// Parameterized 4-input gate module implemented using reduction operators internally for optimal synthesis
module FourInputGate #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output       out
);
    generate
        if (GATETYPE == "AND") begin
            assign out = &in;
        end else if (GATETYPE == "OR") begin
            assign out = |in;
        end else if (GATETYPE == "XOR") begin
            assign out = ^in;
        end else begin
            assign out = 1'b0; // default safe output
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