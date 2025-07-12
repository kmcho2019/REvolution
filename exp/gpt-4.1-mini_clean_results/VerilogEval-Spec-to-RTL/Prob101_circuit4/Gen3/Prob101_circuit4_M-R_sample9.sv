module TopModule(
    input  a,  // Unused input, present for interface completeness
    input  b,  // Input contributing directly to output q
    input  c,  // Input contributing directly to output q
    input  d,  // Unused input, present for interface completeness
    output reg q   // Output is high if either b or c is high
);

    // Combinational logic implemented in always_comb block.
    // Whenever b or c changes, q updates accordingly.
    always @(*) begin
        q = b | c;
    end

endmodule