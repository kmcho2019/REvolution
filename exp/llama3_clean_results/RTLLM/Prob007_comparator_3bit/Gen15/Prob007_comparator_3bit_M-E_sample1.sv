module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

wire [2:0] result;
wire borrow_out;

// Calculate A - B
assign result[0] = A[0] ^ B[0];
assign result[1] = A[1] ^ B[1] ^ borrow_out;
assign result[2] = A[2] ^ B[2];

// Determine borrow out for each bit position
assign borrow_out = (A[0] & ~B[0]) | (~A[1] & B[1]) | (~A[2] & B[2]);

// Determine comparison outcomes
always @(*)
begin
    if (result[2] == 1'b1) // Result is negative, A is less than B
    begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
    else if (result == 3'b0) // Result is zero, A is equal to B
    begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end
    else // Result is positive, A is greater than B
    begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
end

endmodule