module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Intermediate signal to hold the XOR result

// Combinational logic for XOR operation
assign next_out = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= next_out; // Update out at each positive clock edge
end

endmodule