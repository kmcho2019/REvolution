// Define a module to compare two bits
module bit_comparator(
    input A,
    input B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    if (A > B) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A == B) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule

// Define the 3-bit comparator module using the bit_comparator
module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Instantiate bit comparators for each bit position
bit_comparator comp_msbs(A[2], B[2], msb_greater, msb_equal, msb_less);
bit_comparator comp_midbits(A[1], B[1], midbit_greater, midbit_equal, midbit_less);
bit_comparator comp_lsbs(A[0], B[0], lsb_greater, lsb_equal, lsb_less);

// Determine final outputs based on sub-comparisons
always @(*)
begin
    if (msb_greater) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (msb_less) begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else if (msb_equal) begin
        if (midbit_greater) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (midbit_less) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (midbit_equal) begin
            if (lsb_greater) begin
                A_greater = 1'b1;
                A_equal = 1'b0;
                A_less = 1'b0;
            end else if (lsb_less) begin
                A_greater = 1'b0;
                A_equal = 1'b0;
                A_less = 1'b1;
            end else begin
                A_greater = 1'b0;
                A_equal = 1'b1;
                A_less = 1'b0;
            end
        end
    end
end

endmodule