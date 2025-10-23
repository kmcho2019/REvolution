// Parameterized 4-input gate module using balanced tree logic implemented via reduction operator
module FourInputGate #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output       out
);
    generate
        if (GATETYPE == "AND") begin
            // Reduction AND directly implements a balanced AND tree efficiently
            assign out = &in;
        end else if (GATETYPE == "OR") begin
            // Reduction OR directly implements a balanced OR tree efficiently
            assign out = |in;
        end else if (GATETYPE == "XOR") begin
            // Reduction XOR directly implements a balanced XOR tree efficiently
            assign out = ^in;
        end else begin
            assign out = 1'b0; // Default safe output
        end
    endgenerate
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate parameterized 4-input gates for each output using concise and explicit logic
    FourInputGate #(.GATETYPE("AND")) u_and (.in(in), .out(out_and));
    FourInputGate #(.GATETYPE("OR"))  u_or  (.in(in), .out(out_or));
    FourInputGate #(.GATETYPE("XOR")) u_xor (.in(in), .out(out_xor));

endmodule