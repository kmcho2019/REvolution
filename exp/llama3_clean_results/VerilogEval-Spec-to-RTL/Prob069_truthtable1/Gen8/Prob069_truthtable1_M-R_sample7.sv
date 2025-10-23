module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Using an always block for a combinational circuit is less common than assign,
// but it can provide more flexibility for complex designs or when sequential
// logic is involved. For this simple case, it's primarily a matter of style.
always @(*) begin
    // The logic remains the same as in the original assign statement.
    // We're using an intermediate variable for clarity, though in this case,
    // it doesn't provide significant benefits over the original implementation.
    f = (x2 & ~x3) | (x1 & x3);
end

endmodule