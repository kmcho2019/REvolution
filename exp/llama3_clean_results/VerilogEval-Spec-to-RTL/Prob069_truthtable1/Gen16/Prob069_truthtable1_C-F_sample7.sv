module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*)
begin
    // Simplified logical expression from Example 1
    f = (x2 && !x3) || (x1 && x3);
end

endmodule