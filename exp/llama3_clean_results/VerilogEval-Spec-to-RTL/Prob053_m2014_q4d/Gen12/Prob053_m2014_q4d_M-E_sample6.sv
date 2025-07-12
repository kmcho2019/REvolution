module TopModule(
    input clk,
    input in,
    output out
);

// Internal signal to hold the state of the flip-flop
reg internal_state = 1'b0;

// Combinational logic for XOR operation using the internal state
wire xor_result;
assign xor_result = in ^ internal_state;

// Sequential logic for D flip-flop, update internal_state on the rising edge of clk
always @(posedge clk) begin
    internal_state <= xor_result; // Update internal_state with the computed XOR result at the rising edge of clk
end

// Continuous assignment to output the internal state as 'out'
assign out = internal_state;

endmodule