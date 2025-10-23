module TopModule (
    input clk,
    input L,
    input q_in,  // Current state input (for XOR operation)
    input r_in,  // Load value input
    output Q     // Output state
);

reg q;

// The mux input for when L=0 (normal operation)
wire mux_input = q_in;

// The flip-flop with multiplexed input
always @(posedge clk) begin
    q <= L ? r_in : mux_input;
end

assign Q = q;

endmodule