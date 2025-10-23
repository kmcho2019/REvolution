module TopModule(
    input clk,
    input x,
    output z
);

reg xor_state, and_state, or_state;

// Initial block to reset the flip-flops to 0
initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
end

// Combinational logic for the gates
wire xor_out, and_out, or_out;
assign xor_out = x ^ xor_state;
assign and_out = x & ~and_state;
assign or_out = x | ~or_state;

// Sequential logic for updating the state of the flip-flops
always @(posedge clk) begin
    xor_state <= xor_out;
    and_state <= and_out;
    or_state <= or_out;
end

// Combinational logic for the final output 'z' using a NOR gate
assign z = ~(xor_state | and_state | or_state);

endmodule