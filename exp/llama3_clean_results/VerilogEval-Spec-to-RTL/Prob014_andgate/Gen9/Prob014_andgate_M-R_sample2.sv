module TopModule(
    input  a,
    input  b,
    output reg out
);
// Implementing the 2-input AND gate using a combinational always block.
always @(*) begin
    out = a & b;
end

endmodule