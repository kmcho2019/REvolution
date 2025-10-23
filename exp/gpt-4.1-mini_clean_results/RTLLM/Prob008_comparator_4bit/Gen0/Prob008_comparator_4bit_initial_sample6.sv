module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff;
    wire [3:0] borrow;

    // First bit subtractor
    assign {borrow[0], diff[0]} = {1'b0, A[0]} - B[0];
    // Subsequent bit subtractors with borrow in
    assign {borrow[1], diff[1]} = {borrow[0], A[1]} - B[1];
    assign {borrow[2], diff[2]} = {borrow[1], A[2]} - B[2];
    assign {borrow[3], diff[3]} = {borrow[2], A[3]} - B[3];

    wire borrow_out = borrow[3];
    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow_out;
    assign A_equal   = ~borrow_out & diff_zero;
    assign A_greater = ~borrow_out & ~diff_zero;

endmodule