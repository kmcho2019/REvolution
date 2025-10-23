module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    wire [3:0] diff;
    wire borrow;

    assign diff = A - B;
    assign borrow = (B > A);

    always @(*) begin
        if (borrow) begin
            A_less = 1'b1;
            A_equal = 1'b0;
            A_greater = 1'b0;
        end else if (diff == 4'b0000) begin
            A_equal = 1'b1;
            A_greater = 1'b0;
            A_less = 1'b0;
        end else begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule