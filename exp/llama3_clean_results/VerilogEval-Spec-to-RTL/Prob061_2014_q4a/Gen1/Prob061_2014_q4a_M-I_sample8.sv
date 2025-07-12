module TopModule(
    input clk,  // Clock signal
    input w,    // Input from the previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output Q    // Output of the module
);

reg q_reg;  // Register to store the current value

always @(posedge clk) begin
    if (L) begin
        // Load has priority, so load R if L is high
        q_reg <= R;
    end else if (E) begin
        // If L is not high but E is, shift in the value from w
        q_reg <= w;
    end else begin
        // If neither L nor E is high, retain the current value
        // This is implicit, as we don't assign a new value to q_reg
    end
end

assign Q = q_reg;  // Continuous assignment to output the current value

endmodule