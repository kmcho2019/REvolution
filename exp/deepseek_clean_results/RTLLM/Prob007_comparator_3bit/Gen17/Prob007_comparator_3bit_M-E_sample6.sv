module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Default to equal (will be overridden if inequality found)
    A_greater = 1'b0;
    A_equal = 1'b1;
    A_less = 1'b0;
    
    // Bit-serial comparison with priority encoding
    case (1'b1)
        (A[2] != B[2]): begin
            A_equal = 1'b0;
            if (A[2] > B[2]) A_greater = 1'b1;
            else A_less = 1'b1;
        end
        (A[1] != B[1]): begin
            A_equal = 1'b0;
            if (A[1] > B[1]) A_greater = 1'b1;
            else A_less = 1'b1;
        end
        (A[0] != B[0]): begin
            A_equal = 1'b0;
            if (A[0] > B[0]) A_greater = 1'b1;
            else A_less = 1'b1;
        end
        default: ; // All bits equal (keep defaults)
    endcase
end

endmodule