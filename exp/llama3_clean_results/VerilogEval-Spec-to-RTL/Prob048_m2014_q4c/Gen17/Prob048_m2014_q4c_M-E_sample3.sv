module TopModule(
    input  logic clk,  // Clock signal
    input  logic d,    // Data input
    input  logic r,    // Reset signal (active high)
    output logic q      // Output
);

logic mux_out; // Output of the multiplexer

// Multiplexer to select between data and reset value
always_comb begin
    // If reset is high, select 0, otherwise select the data input
    mux_out = r ? 1'b0 : d;
end

// D flip-flop to capture the selected value on the positive edge of the clock
always @(posedge clk) begin
    q <= mux_out;
end

endmodule