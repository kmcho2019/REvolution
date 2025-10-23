module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B using combinational logic
// We could use a 4-bit subtractor but for simplicity, 
// we directly calculate the result and borrow in verilog
wire [3:0] diff;
wire borrow;

assign {borrow, diff} = A - B;

// Determine A_greater, A_equal, A_less based on result and borrow
assign A_greater = (borrow == 0 && diff != 0);
assign A_equal = (borrow == 0 && diff == 0);
assign A_less = borrow;

endmodule