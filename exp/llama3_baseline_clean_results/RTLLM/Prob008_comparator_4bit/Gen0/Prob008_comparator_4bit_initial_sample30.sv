module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Internal wires to hold the result of subtraction and borrow
wire [3:0] result;
wire borrow;

// Perform subtraction A - B and generate borrow
assign {borrow, result} = A - B;

// Determine A_greater, A_equal, A_less based on result and borrow
always @(*) begin
    if (borrow == 1'b1) begin // Borrow occurred, A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else if (result == 4'b0) begin // Result is zero, A equals B
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin // No borrow and result is not zero, A is greater than B
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
end

endmodule