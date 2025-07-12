module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Compare the most significant bits (MSBs)
    if (A[2] > B[2]) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A[2] < B[2]) begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else begin
        // If MSBs are equal, compare the middle bits
        if (A[1] > B[1]) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (A[1] < B[1]) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else begin
            // If middle bits are equal, compare the least significant bits
            if (A[0] > B[0]) begin
                A_greater = 1'b1;
                A_equal = 1'b0;
                A_less = 1'b0;
            end else if (A[0] < B[0]) begin
                A_greater = 1'b0;
                A_equal = 1'b0;
                A_less = 1'b1;
            end else begin
                // If all bits are equal, set A_equal to 1
                A_greater = 1'b0;
                A_equal = 1'b1;
                A_less = 1'b0;
            end
        end
    end
end

endmodule