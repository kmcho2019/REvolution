module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Simplified logical expression for better readability and maintainability
always @(*)
begin
    // Implementing the logic based on the truth table conditions
    f = (x2 && !x3) || (x1 && x3);
end

endmodule