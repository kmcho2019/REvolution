module TopModule(
    input  a,
    input  b,
    output reg out
);
// Implementing the AND gate using an always block with combinational logic
always @(*) begin
    out = a & b;
end

endmodule