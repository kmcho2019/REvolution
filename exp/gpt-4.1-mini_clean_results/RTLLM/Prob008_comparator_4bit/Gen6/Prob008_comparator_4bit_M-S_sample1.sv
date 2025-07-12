module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output      A_greater,
    output      A_equal,
    output      A_less
);

    wire [4:0] diff_ext;    // extended subtraction result to capture borrow
    wire       borrow_out;
    wire       equal_flag;

    assign diff_ext = {1'b0, A} - {1'b0, B}; // 5-bit subtraction to get borrow_out
    assign borrow_out = diff_ext[4];          // borrow_out is MSB
    assign equal_flag = ~( |(A ^ B) );        // true if A == B

    assign A_less    = borrow_out;
    assign A_equal   = ~borrow_out & equal_flag;
    assign A_greater = ~borrow_out & ~equal_flag;

endmodule