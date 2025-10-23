module TopModule(
    input clk,  // Clock signal
    input w,    // Input from the previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output Q    // Output of the module
);

reg q_reg;  // Register to store the current value

// Combinational logic to generate next_q
wire next_q;
assign next_q = (L) ? R : (E) ? w : q_reg;

always @(posedge clk) begin
    q_reg <= next_q;
end

assign Q = q_reg;  // Continuous assignment to output the current value

endmodule