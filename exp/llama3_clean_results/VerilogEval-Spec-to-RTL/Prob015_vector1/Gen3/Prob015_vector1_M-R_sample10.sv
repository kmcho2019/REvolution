// TopModule: A combinational circuit that splits a 16-bit input into two 8-bit outputs.
//            out_hi contains the upper 8 bits of the input, and out_lo contains the lower 8 bits.

module TopModule(
    // 16-bit input
    input  [15:0] in,
    // 8-bit output containing the upper 8 bits of the input
    output [7:0]  out_hi,
    // 8-bit output containing the lower 8 bits of the input
    output [7:0]  out_lo
);

    // Use an always block for the combinational logic
    always @(*) begin
        // Assign the upper 8 bits of the input to out_hi
        out_hi = in[15:8];
        // Assign the lower 8 bits of the input to out_lo
        out_lo = in[7:0];
    end

endmodule