module TopModule(
    input clk,  // Clock signal
    input w,     // Input from previous stage
    input R,     // Value to load
    input E,     // Enable shift
    input L,     // Load signal
    output reg Q // Output of the module
);

always @(posedge clk) begin
    if (L) begin
        // If load is asserted, load the value of R into Q
        Q <= R;
    end else if (E) begin
        // If shift is enabled and not loading, shift in the value from w
        Q <= w;
    end
end

endmodule