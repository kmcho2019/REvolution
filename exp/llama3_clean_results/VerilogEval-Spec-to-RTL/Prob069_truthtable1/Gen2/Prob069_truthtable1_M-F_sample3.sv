module TopModule(
    input x3,
    input x2,
    input x1,
    output logic f
);

always @(*)
begin
    // Directly implement the logic based on the truth table conditions
    f = (x2 && !x3 && (x1 || !x1)) || (x1 && x3 && !x2) || (x1 && x2 && x3);
end

endmodule