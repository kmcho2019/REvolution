module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    always @(*) begin
        // Default outputs
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
        
        // MSB (bit 2) comparison
        if (A[2] != B[2]) begin
            A_equal = 1'b0;
            A_greater = A[2];
            A_less = ~A[2];
        end
        // Only compare lower bits if higher bits are equal
        else if (A[1] != B[1]) begin
            A_equal = 1'b0;
            A_greater = A[1];
            A_less = ~A[1];
        end
        else if (A[0] != B[0]) begin
            A_equal = 1'b0;
            A_greater = A[0];
            A_less = ~A[0];
        end
    end

endmodule