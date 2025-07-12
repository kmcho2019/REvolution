module TopModule(
    input in1,
    input in2,
    output reg out
);

// Refactored implementation using an always block
always @(*) begin
    out = in1 & ~in2;
end

endmodule