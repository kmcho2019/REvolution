module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        // Create a 32-bit signed value by shifting left then arithmetic right shift
        // This sign-extends the 8-bit input to 32 bits.
        out = {{24{1'b0}}, in} << 24;     // Shift left to position MSB at bit 31
        out = $signed(out) >>> 24;        // Arithmetic right shift to sign-extend
    end

endmodule