module TopModule(
    input clk, // Clock signal
    input w,   // Input from the previous stage
    input R,   // Value to load
    input E,   // Enable shift
    input L,   // Load signal
    output reg Q // Output of the current stage
);

always @(posedge clk) begin
    if (L) begin
        // If load signal is high, load the value of R into Q
        Q <= R;
    end else if (E) begin
        // If enable shift is high and load is not, shift w into Q
        Q <= w;
    end
end

endmodule