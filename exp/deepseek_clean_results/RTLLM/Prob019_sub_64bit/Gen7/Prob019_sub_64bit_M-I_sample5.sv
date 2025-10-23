module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    input enable,  // Operand isolation control
    output reg signed [63:0] result,
    output reg overflow
);

    always_comb begin
        if (enable) begin
            // Calculate result
            result = A - B;
            
            // Simplified overflow detection:
            // Overflow occurs when signs of A and B differ and result sign differs from A sign
            overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);
        end
        else begin
            // Operand isolation - maintain previous outputs when disabled
            result = result;
            overflow = overflow;
        end
    end

endmodule