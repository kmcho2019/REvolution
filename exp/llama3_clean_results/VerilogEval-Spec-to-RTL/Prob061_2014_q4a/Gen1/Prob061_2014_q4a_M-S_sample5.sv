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
        q_reg <= R;
    end else if (E) begin
        q_reg <= w;
    end
end

assign Q = q_reg;  // Continuous assignment to output the current value

endmodule