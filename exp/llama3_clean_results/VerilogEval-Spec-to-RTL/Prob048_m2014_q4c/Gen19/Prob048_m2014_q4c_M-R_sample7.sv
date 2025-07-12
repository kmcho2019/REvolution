module TopModule(
    input  logic clk,  // Clock signal
    input  logic d,    // Data input
    input  logic r,    // Reset signal (active high)
    output logic q      // Output
);

// D flip-flop to capture the selected value on the positive edge of the clock
always @(posedge clk) begin
    // If reset is high, select 0, otherwise select the data input
    q <= r? 1'b0 : d;
end

endmodule