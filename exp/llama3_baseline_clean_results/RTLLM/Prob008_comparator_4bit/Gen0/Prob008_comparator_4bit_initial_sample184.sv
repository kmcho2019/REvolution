module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Calculate the difference between A and B
    wire [3:0] diff;
    assign diff = A - B;

    // Check for borrow (i.e., A is less than B)
    wire borrow;
    assign borrow = (A < B) ? 1'b1 : 1'b0;

    // Determine the output based on the difference and borrow
    always @(A, B) begin
        if (borrow) begin
            A_less = 1'b1;
            A_greater = 1'b0;
            A_equal = 1'b0;
        end else if (diff == 4'b0000) begin
            A_less = 1'b0;
            A_greater = 1'b0;
            A_equal = 1'b1;
        end else begin
            A_less = 1'b0;
            A_greater = 1'b1;
            A_equal = 1'b0;
        end
    end

endmodule