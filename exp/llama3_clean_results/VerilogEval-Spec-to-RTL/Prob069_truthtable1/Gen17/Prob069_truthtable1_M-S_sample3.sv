module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*)
begin
    // Simplified expression based on truth table analysis
    f = x2 | (x3 & x1);
end

endmodule