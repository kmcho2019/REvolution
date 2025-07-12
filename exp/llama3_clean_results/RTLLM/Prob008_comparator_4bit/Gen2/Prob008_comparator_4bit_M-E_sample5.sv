module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output reg A_greater,  // 1-bit output indicating if A is greater than B
    output reg A_equal,   // 1-bit output indicating if A is equal to B
    output reg A_less    // 1-bit output indicating if A is less than B
);

// Hierarchical comparison logic
always @(*) begin
    // Initialize outputs to default values
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;

    // Compare MSB first
    if (A[3] > B[3]) begin
        A_greater = 1'b1;
    end else if (A[3] < B[3]) begin
        A_less = 1'b1;
    end else begin
        // If MSBs are equal, compare the next bits
        if (A[2] > B[2]) begin
            A_greater = 1'b1;
        end else if (A[2] < B[2]) begin
            A_less = 1'b1;
        end else begin
            // If the first two bits are equal, compare the next bits
            if (A[1] > B[1]) begin
                A_greater = 1'b1;
            end else if (A[1] < B[1]) begin
                A_less = 1'b1;
            end else begin
                // If the first three bits are equal, compare the LSBs
                if (A[0] > B[0]) begin
                    A_greater = 1'b1;
                end else if (A[0] < B[0]) begin
                    A_less = 1'b1;
                end else begin
                    // If all bits are equal, A is equal to B
                    A_equal = 1'b1;
                end
            end
        end
    end
end

endmodule