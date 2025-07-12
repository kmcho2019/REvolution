module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

// Set initial state of clock signal
reg clk = 0;

// Check if PERIOD is even
initial begin
    if (PERIOD % 2 != 0) begin
        $display("Error: PERIOD must be an even number.");
        $finish;
    end
end

// Use a single always block with a sensitivity list
always @(clk) begin
    #((PERIOD / 2)); // wait for half of the period
    clk = ~clk; // toggle the clock signal
end

endmodule