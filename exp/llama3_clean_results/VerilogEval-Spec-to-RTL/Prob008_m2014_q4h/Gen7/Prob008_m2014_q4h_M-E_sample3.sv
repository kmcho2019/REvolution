// Module TopModule: A simple sequential logic circuit that assigns the output port 'out' to the same value as the input port 'in' after a clock cycle.
module TopModule(
    input  logic clk,  // Clock signal
    input  logic in,  // Input port
    output logic out  // Output port
);

// Internal signal to hold the latched input value
logic latch_in;

// Sequential process to latch the input value on the rising edge of the clock
always_ff @(posedge clk) begin
    latch_in <= in;
end

// Continuous assignment to drive the output with the latched input value
assign out = latch_in;

endmodule