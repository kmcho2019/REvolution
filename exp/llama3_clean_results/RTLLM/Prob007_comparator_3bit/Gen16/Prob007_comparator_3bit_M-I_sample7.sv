module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Reset all outputs to avoid unintended values
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;

    // Compare A and B, and set the appropriate output high
    if (A > B) begin
        A_greater = 1'b1;
    end else if (A == B) begin
        A_equal = 1'b1;
    end else begin
        A_less = 1'b1;
    end
end

endmodule