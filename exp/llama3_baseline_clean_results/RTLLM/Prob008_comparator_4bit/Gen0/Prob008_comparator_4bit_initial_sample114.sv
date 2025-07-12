module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff;
wire borrow;

assign diff = A - B;
assign borrow = (A < B) ? 1'b1 : 1'b0;

always @(*) begin
    if (borrow) begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else if (diff == 4'b0000) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
end

endmodule