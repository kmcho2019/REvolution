module TopModule(
    input clk,  // Clock signal
    input w,    // Input from previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load enable
    output Q    // Output of current stage
);

reg q_reg;  // Internal register to store the output

always @(posedge clk) begin
    if (L) begin  // If load is enabled, load the value from R
        q_reg <= R;
    end else if (E) begin  // If shift is enabled, shift the value from w
        q_reg <= w;
    end
end

assign Q = q_reg;  // Assign the internal register to the output

endmodule