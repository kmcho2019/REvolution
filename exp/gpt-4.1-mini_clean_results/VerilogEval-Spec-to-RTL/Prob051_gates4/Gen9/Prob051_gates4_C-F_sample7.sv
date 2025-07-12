module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Declare outputs as wire implicitly (default) and use always_comb for clarity.
    // This requires SystemVerilog for always_comb.
    // If only Verilog-2001, use always @(*) and assign outputs as reg instead.

    // Use a named block for combinational logic for clear grouping without intermediate wires.
    // Single-step reduction operators used directly for best PPA.

    // Internal signals to hold outputs (combinational)
    wire and_val, or_val, xor_val;

    always @(*) begin
        // Combinational reduction operators on entire input vector
        // Synthesis will infer minimal depth gates for these
        and_val = &in;
        or_val  = |in;
        xor_val = ^in;
    end

    // Continuous assignment of outputs from internal wires
    assign out_and = and_val;
    assign out_or  = or_val;
    assign out_xor = xor_val;

endmodule