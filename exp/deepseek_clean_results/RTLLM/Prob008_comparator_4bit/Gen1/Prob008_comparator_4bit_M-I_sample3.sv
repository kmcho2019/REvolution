module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Default assignments
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;
    
    // MSB first comparison
    if (A[3] ^ B[3]) begin
        A_greater = A[3] & ~B[3];
        A_less = ~A[3] & B[3];
    end
    else if (A[2] ^ B[2]) begin
        A_greater = A[2] & ~B[2];
        A_less = ~A[2] & B[2];
    end
    else if (A[1] ^ B[1]) begin
        A_greater = A[1] & ~B[1];
        A_less = ~A[1] & B[1];
    end
    else if (A[0] ^ B[0]) begin
        A_greater = A[0] & ~B[0];
        A_less = ~A[0] & B[0];
    end
    else begin
        A_equal = 1'b1;
    end
end

endmodule