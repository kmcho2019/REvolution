module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinatorial logic: XOR operation
wire d = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= d;  // Update the flip-flop's output with the XOR result
end

// No explicit initialization needed as the default value of 'out' in most tools will be 1'b0 or a don't-care, and it gets updated at the first clock edge

endmodule