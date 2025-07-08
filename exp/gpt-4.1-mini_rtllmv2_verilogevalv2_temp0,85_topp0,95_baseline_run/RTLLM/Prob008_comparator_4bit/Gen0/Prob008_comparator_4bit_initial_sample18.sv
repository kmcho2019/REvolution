module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire [3:0] diff;
wire borrow_out;

// 4-bit subtraction: diff = A - B
// borrow_out indicates if borrow happened (A < B)
assign {borrow_out, diff} = {1'b0, A} - {1'b0, B};

// Determine outputs based on borrow_out and diff
assign A_less    = borrow_out;
assign A_equal   = (~borrow_out) & (diff == 4'b0000);
assign A_greater = (~borrow_out) & (diff != 4'b0000);

endmodule