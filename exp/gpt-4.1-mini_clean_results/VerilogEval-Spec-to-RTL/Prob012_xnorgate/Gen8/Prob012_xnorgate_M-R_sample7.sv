module TopModule (
    input wire a,
    input wire b,
    output reg out
);

// Implement XNOR gate using procedural assignment in an always_comb block
always @(*) begin
    out = ~(a ^ b);
end

endmodule