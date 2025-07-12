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
        // If load is asserted, load the value from R
        q_reg <= R;
    end else if (E) begin
        // If enable is asserted and load is not, shift in the value from w
        q_reg <= w;
    end
    // If neither load nor enable is asserted, retain the current value
end

assign Q = q_reg;  // Continuous assignment to output the current value

endmodule