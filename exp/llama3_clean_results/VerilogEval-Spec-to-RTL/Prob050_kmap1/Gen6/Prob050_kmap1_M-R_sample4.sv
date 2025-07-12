module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

// Refactored version using an always block for combinational logic
always @(*) begin
    out = a | b | c;
end

endmodule