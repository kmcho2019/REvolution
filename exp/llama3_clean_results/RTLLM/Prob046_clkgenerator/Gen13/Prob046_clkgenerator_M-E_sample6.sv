module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [PERIOD-1:0] flip_flops; // Array of flip-flops
integer i; // Loop variable

always @(posedge flip_flops[PERIOD-1]) begin
    // Shift the values through the flip-flops
    for (i = PERIOD-1; i > 0; i = i - 1) begin
        flip_flops[i] <= flip_flops[i-1];
    end
    // Feedback the output of the last flip-flop to the first
    flip_flops[0] <= ~flip_flops[PERIOD-1];
end

// Initialize the first flip-flop to start the clock signal
initial begin
    flip_flops[0] = 1'b1; // Start with the first flip-flop high
    for (i = 1; i < PERIOD; i++) begin
        flip_flops[i] = 1'b0; // Reset all other flip-flops
    end
    // Drive the output clock signal
    forever begin
        #1; // Wait for 1 time unit
        clk = flip_flops[PERIOD-1]; // Output the clock signal
    end
end

endmodule