module FourInputGate #(
    parameter GATETYPE = "AND"
) (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;

    // Balanced 2-input gate tree using reduction operators on pairs
    generate
        if (GATETYPE == "AND") begin
            assign level1_0 = &in[1:0];
            assign level1_1 = &in[3:2];
            assign out = level1_0 & level1_1;
        end else if (GATETYPE == "OR") begin
            assign level1_0 = |in[1:0];
            assign level1_1 = |in[3:2];
            assign out = level1_0 | level1_1;
        end else if (GATETYPE == "XOR") begin
            assign level1_0 = ^in[1:0];
            assign level1_1 = ^in[3:2];
            assign out = level1_0 ^ level1_1;
        end else begin
            assign out = 1'b0; // safe default for unsupported types
        end
    endgenerate
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Share partial results of pairs to reduce redundant logic and switching
    wire and_01, and_23;
    wire or_01,  or_23;
    wire xor_01, xor_23;

    // Partial computations for input pairs
    assign and_01 = &in[1:0];
    assign and_23 = &in[3:2];
    assign or_01  = |in[1:0];
    assign or_23  = |in[3:2];
    assign xor_01 = ^in[1:0];
    assign xor_23 = ^in[3:2];

    // Combine partials for final outputs
    assign out_and = and_01 & and_23;
    assign out_or  = or_01  | or_23;
    assign out_xor = xor_01 ^ xor_23;
endmodule