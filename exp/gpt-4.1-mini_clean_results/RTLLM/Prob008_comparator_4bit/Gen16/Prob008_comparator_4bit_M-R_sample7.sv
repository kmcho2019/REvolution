module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Function to compute borrow chain for subtraction A - B
    function [4:0] calc_borrow;
        input [3:0] x, y;
        integer i;
        reg borrow_in;
        reg [4:0] borrows;
        begin
            borrow_in = 1'b0;
            borrows = 5'b0;
            for (i = 0; i < 4; i = i +1) begin
                // borrow generated if y[i] > x[i] + borrow_in
                borrows[i] = (~x[i] & (y[i] | borrow_in)) | (y[i] & borrow_in);
                borrow_in = borrows[i];
            end
            borrows[4] = borrow_in; // final borrow out
            calc_borrow = borrows;
        end
    endfunction

    wire [4:0] borrows = calc_borrow(A, B);

    // Equality when all bits are equal
    wire equal_bits = &(~(A ^ B)); // bitwise XNOR reduction

    assign A_less    = borrows[4];       // final borrow out indicates A < B
    assign A_equal   = equal_bits;       // all bits equal
    assign A_greater = ~(borrows[4] | equal_bits); // not less and not equal => greater

endmodule