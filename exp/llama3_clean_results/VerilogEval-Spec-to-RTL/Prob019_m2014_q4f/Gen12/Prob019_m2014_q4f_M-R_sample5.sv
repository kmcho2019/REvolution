module TopModule(
    input in1,
    input in2,
    output out
);

// Refactored code using an always block for clarity and a continuous assignment
always @(*) begin
    out = in1 & (~in2);
end

endmodule