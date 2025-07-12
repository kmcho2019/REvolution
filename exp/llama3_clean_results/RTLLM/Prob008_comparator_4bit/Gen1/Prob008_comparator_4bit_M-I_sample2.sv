module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

wire [3:0] diff;
wire borrow;

// Invert B's bits and add 1 to simulate subtraction A - B using an adder
wire [3:0] B_inv = ~B;
assign diff[0] = A[0] ^ B_inv[0] ^ 1;
assign borrow = A[0] & (~B_inv[0]) & (~1) | (~A[0]) & B_inv[0] & (~1) | borrow;

// Perform the rest of the addition/subtraction
assign diff[1] = A[1] ^ B_inv[1] ^ borrow;
assign borrow = A[1] & (~B_inv[1]) & (~borrow) | (~A[1]) & B_inv[1] & (~borrow);

assign diff[2] = A[2] ^ B_inv[2] ^ borrow;
assign borrow = A[2] & (~B_inv[2]) & (~borrow) | (~A[2]) & B_inv[2] & (~borrow);

assign diff[3] = A[3] ^ B_inv[3] ^ borrow;
assign borrow = A[3] & (~B_inv[3]) & (~borrow) | (~A[3]) & B_inv[3] & (~borrow);

// Determine A_greater, A_equal, A_less based on the result of the subtraction
always @(*) begin
    if (~borrow) begin
        if (~|diff) begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule