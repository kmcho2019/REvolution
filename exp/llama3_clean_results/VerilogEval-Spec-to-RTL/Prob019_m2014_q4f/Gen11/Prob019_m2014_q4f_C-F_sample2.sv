module TopModule(
    input in1,
    input in2,
    output reg out
);

always @(*) begin
    // Explicitly invert in2 before AND operation for clarity and efficiency
    out = in1 & (~in2);
end

endmodule