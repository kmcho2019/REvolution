module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;
    reg [7:0]  shift_A;

    always @(A or B) begin
        prod = 0;
        shift_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                prod = prod + {shift_A, 8'd0};
            end
            shift_A = shift_A << 1;
        end
    end

    assign product = prod;

endmodule