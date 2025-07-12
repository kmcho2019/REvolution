module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    wire [4:0] sum;

    assign sum = {1'b0, A} + {4'b0, ~B} + 1'b1; // Perform A - B by inverting B and adding 1

    always @(*)
    begin
        A_equal = (A == B);
        A_greater = (~A_equal) && (sum[4] == 0); // No borrow, A is greater
        A_less = (~A_equal) && (sum[4] == 1); // Borrow occurred, A is less
    end

endmodule