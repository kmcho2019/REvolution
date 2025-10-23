module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize the output to a default value ( in this case) to ensure it's defined at the start of simulation
initial q = 0;

// Use a non-blocking assignment to update the flip-flop's state on the positive edge of the clock
always @(posedge clk)
    q <= d;

endmodule