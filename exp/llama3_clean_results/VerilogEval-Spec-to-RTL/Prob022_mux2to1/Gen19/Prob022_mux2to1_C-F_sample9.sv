module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);
// Implement the multiplexer using an always block with the ternary operator
always @(*) begin
    out = sel ? b : a;
end
endmodule