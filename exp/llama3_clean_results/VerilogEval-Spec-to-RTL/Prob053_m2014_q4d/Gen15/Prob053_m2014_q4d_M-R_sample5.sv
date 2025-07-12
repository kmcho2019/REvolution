module TopModule(
    input clk,
    input in,
    output reg out
);

// Internal state of the D flip-flop
reg internal_state;

// Combinational logic to compute the XOR result
assign out = internal_state;

// Sequential logic for D flip-flop, update internal_state on the rising edge of clk
always @(posedge clk) begin
    internal_state <= in ^ out; // Update internal_state with the computed XOR result
end

endmodule