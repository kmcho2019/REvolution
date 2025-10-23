module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;
    reg [7:0]  a;
    reg [7:0]  b;

    integer i;

    always @(*) begin
        prod = 0;
        a = A;
        b = B;
        for (i = 0; i < 8; i = i + 1) begin
            if (b[0]) begin
                prod = prod + (a << i);
            end
            b = b >> 1;
        end
    end

    assign product = prod;

endmodule