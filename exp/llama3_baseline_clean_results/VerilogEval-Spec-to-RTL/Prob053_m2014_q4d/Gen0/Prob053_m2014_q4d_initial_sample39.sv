module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_ff; // Internal signal for the D flip-flop output

always @ (posedge clk) begin
    out_ff <= in ^ out; // XOR operation and assignment to flip-flop input
end

assign out = out_ff; // Continuous assignment to output

endmodule