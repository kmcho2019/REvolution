module TopModule(
    input clk,
    input in,
    output reg out
);

reg d;

always @(*) begin
    d = in ^ out; // XOR gate
end

always @(posedge clk) begin
    out <= d; // D flip-flop
end

endmodule