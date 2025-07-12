module TopModule(
    input  clk, // Clock signal
    input  d,   // Data input
    input  r,   // Active high synchronous reset
    output reg q // Output
);

// Always block triggered at the positive edge of the clock signal
always @(posedge clk) begin
    // If the reset signal is high, reset the output to 0
    if (r) begin
        // Synchronous reset to 0 when r is high
        q <= 1'b0;
    end else begin
        // Otherwise, assign the input to the output
        q <= d;
    end
end

endmodule