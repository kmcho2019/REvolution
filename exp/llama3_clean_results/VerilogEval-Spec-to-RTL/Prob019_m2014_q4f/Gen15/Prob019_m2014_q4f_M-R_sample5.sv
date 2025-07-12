module TopModule(
    input in1,
    input in2,
    output reg out
);

// Sensitivity list includes all inputs to ensure combinational logic behavior
always @(*)
begin
    // Implement the required logic inside the always block
    out = in1 & ~in2;
end

endmodule