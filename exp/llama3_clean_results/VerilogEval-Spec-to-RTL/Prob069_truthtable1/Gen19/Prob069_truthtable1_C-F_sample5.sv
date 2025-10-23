module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*) begin
    // Simplified implementation based on the truth table conditions.
    f = (~x3 & x2) | (x3 & x1);
end

endmodule