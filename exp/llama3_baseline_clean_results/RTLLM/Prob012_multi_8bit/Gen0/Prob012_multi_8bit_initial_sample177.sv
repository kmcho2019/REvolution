module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] prod;
reg [7:0] temp_A;
integer i;

initial begin
    prod = 0;
    temp_A = A;
end

always @(A or B) begin
    prod = 0;
    temp_A = A;
    for (i = 0; i < 8; i = i + 1) begin
        if (B[i] == 1'b1) begin
            prod = prod + (temp_A << i);
        end
        // Shift multiplicand for next iteration, but note that
        // shifting left by one bit is equivalent to multiplying by 2,
        // so we can simply use the << operator or multiply by 2 for this purpose.
        // However, to keep the multiplicand within 8 bits for the next iteration,
        // we don't shift temp_A here. Instead, we directly use (temp_A << i) for addition.
    end
    product = prod;
end

endmodule