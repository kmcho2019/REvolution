module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Directly assign comparison results to output signals
    // Ensure mutual exclusivity by setting other signals to 0 when a condition is met
    if (A > B) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A < B) begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end
end

endmodule