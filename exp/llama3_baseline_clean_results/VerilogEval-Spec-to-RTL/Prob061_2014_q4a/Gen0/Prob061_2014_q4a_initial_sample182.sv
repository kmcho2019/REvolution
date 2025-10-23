module TopModule(
    input clk,  // Clock signal
    input w,   // Input from previous stage
    input R,   // Value to load
    input E,   // Enable shift
    input L,   // Load signal
    output Q   // Output
);

reg q_reg;  // Internal register to store the state

// Initialize the output
assign Q = q_reg;

// D flip-flop with asynchronous load
always @(posedge clk) begin
    if (L) begin
        // Load the value from input R
        q_reg <= R;
    end else if (E) begin
        // Shift in the value from previous stage
        q_reg <= w;
    end else begin
        // Hold the current state
        q_reg <= q_reg;
    end
end

endmodule