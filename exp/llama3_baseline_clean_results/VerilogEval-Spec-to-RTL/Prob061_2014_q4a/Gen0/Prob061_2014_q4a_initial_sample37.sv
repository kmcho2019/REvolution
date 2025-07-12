module TopModule(
    input clk,  // Clock signal
    input w,   // Input from previous stage
    input R,   // Value to load
    input E,   // Enable shift
    input L,   // Load signal
    output reg Q  // Output of this stage
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;  // Load R into Q when L is high
    end else if (E) begin
        Q <= w;  // Shift w into Q when E is high and L is low
    end
end

endmodule