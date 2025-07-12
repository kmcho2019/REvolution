module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    always @(*) begin
        if (A[2] > B[2]) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (A[2] < B[2]) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (A[1] > B[1]) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (A[1] < B[1]) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (A[0] > B[0]) begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end else if (A[0] < B[0]) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end
    end

endmodule