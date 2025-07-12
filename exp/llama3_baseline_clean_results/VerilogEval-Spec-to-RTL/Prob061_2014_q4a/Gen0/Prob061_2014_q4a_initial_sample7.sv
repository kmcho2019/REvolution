module TopModule(
    input clk,  // Clock signal
    input w,    // Input from previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load enable
    output Q    // Output
);

reg q_reg;  // Register to hold the state
assign Q = q_reg;  // Output is the current state of the register

always @ (posedge clk) begin
    if (L) begin  // If load is enabled, load the value R
        q_reg <= R;
    end else if (E) begin  // If shift is enabled, shift the value from previous stage
        q_reg <= w;
    end
end

endmodule