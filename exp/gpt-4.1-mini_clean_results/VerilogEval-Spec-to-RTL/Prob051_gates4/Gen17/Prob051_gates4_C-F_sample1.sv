// Parameterized 4-input gate module using 2-input gate structure but implemented with reduction operators internally
module FourInputGate #(parameter GATETYPE = "AND") (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;

    // Use reduction operators to synthesize balanced gates efficiently
    generate
        if (GATETYPE == "AND") begin
            // Balanced AND tree using reduction AND on pairs
            assign level1_0 = &in[1:0];
            assign level1_1 = &in[3:2];
            assign out = level1_0 & level1_1;
        end else if (GATETYPE == "OR") begin
            // Balanced OR tree using reduction OR on pairs
            assign level1_0 = |in[1:0];
            assign level1_1 = |in[3:2];
            assign out = level1_0 | level1_1;
        end else if (GATETYPE == "XOR") begin
            // Balanced XOR tree using reduction XOR on pairs
            assign level1_0 = ^in[1:0];
            assign level1_1 = ^in[3:2];
            assign out = level1_0 ^ level1_1;
        end else begin
            assign out = 1'b0; // safe default
        end
    endgenerate
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate parameterized gate modules for each output with clear, concise connections
    FourInputGate #(.GATETYPE("AND")) u_and (.in(in), .out(out_and));
    FourInputGate #(.GATETYPE("OR"))  u_or  (.in(in), .out(out_or));
    FourInputGate #(.GATETYPE("XOR")) u_xor (.in(in), .out(out_xor));
endmodule