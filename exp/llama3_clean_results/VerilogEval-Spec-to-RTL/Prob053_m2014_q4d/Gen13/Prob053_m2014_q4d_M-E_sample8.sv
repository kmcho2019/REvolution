module TopModule(
    input clk,
    input in,
    output reg out
);

// Internal signal to hold the current state of the flip-flop
reg internal_state;

// Combinational logic to compute the XOR result using the internal state
wire xor_result;
assign xor_result = in ^ internal_state;

// Sequential logic for D flip-flop, explicitly defining the behavior
always @(posedge clk) begin
    // Update internal_state with the computed XOR result at the rising edge of clk
    internal_state <= xor_result;
    // Update out with the internal state
    out <= internal_state;
end

// Initial block to initialize internal_state and out at the start of the simulation
initial begin
    internal_state = 1'b0;
    out = 1'b0;
end

endmodule