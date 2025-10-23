module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Initialize outputs to avoid latches
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;

    // Compare MSB first
    if (A[2] > B[2]) begin
        A_greater = 1'b1;
    end else if (A[2] < B[2]) begin
        A_less = 1'b1;
    end else begin
        // If MSBs are equal, compare the next bit
        if (A[1] > B[1]) begin
            A_greater = 1'b1;
        end else if (A[1] < B[1]) begin
            A_less = 1'b1;
        end else begin
            // If the first two bits are equal, compare the LSB
            if (A[0] > B[0]) begin
                A_greater = 1'b1;
            end else if (A[0] < B[0]) begin
                A_less = 1'b1;
            end else begin
                // If all bits are equal
                A_equal = 1'b1;
            end
        end
    end
end

endmodule