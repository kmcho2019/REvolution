module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output reg   A_greater,
    output reg   A_equal,
    output reg   A_less
);

    reg [3:0] diff;
    reg [4:0] borrow_chain; // borrow_chain[0] initial borrow (0), borrow_chain[4] final borrow out
    integer i;
    reg equal_flag;

    always @(*) begin
        borrow_chain[0] = 1'b0; // no initial borrow
        for (i = 0; i < 4; i = i + 1) begin
            diff[i] = A[i] ^ B[i] ^ borrow_chain[i];
            // borrow out formula for subtraction:
            // borrow_out = (~A & B) | ((~(A ^ B)) & borrow_in)
            borrow_chain[i+1] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow_chain[i]);
        end

        // Check equality by XOR reduction of all bits; if all zero, inputs are equal
        equal_flag = ~( |(A ^ B) );

        // Assign outputs mutually exclusive
        if (borrow_chain[4] == 1'b1) begin
            A_less    = 1'b1;
            A_equal   = 1'b0;
            A_greater = 1'b0;
        end else if (equal_flag) begin
            A_less    = 1'b0;
            A_equal   = 1'b1;
            A_greater = 1'b0;
        end else begin
            A_less    = 1'b0;
            A_equal   = 1'b0;
            A_greater = 1'b1;
        end
    end

endmodule