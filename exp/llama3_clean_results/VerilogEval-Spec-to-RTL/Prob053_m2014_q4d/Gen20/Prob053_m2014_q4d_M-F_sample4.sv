module TopModule(
    input clk,
    input in,
    output reg out
);

// Explicitly initialize 'out' to avoid any potential issues with initial conditions
initial out = 1'b0;

// Combinatorial logic: XOR operation
wire d = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= d;  // Update the flip-flop's output with the XOR result
end

endmodule