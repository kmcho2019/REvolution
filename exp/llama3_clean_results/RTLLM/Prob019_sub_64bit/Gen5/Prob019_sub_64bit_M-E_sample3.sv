module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Split the 64-bit inputs into two 32-bit parts for hierarchical subtraction
    wire [31:0] A_hi, A_lo, B_hi, B_lo;
    wire [31:0] diff_hi, diff_lo;
    wire carry_in, carry_out;

    assign A_hi = A[63:32];
    assign A_lo = A[31:0];
    assign B_hi = B[63:32];
    assign B_lo = B[31:0];

    // Perform 32-bit subtraction for the lower part
    assign diff_lo = A_lo - B_lo;
    assign carry_in = (A_lo < B_lo) ? 1'b1 : 1'b0;

    // Perform 32-bit subtraction for the higher part, considering the carry from the lower part
    assign diff_hi = A_hi - B_hi - carry_in;
    assign carry_out = (A_hi < B_hi + carry_in) ? 1'b1 : 1'b0;

    // Combine the results of the two 32-bit subtractions
    assign result = {diff_hi, diff_lo};

    // Detect overflow based on the carry-out of the MSB
    always @(*) begin
        if (carry_out != 0) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule