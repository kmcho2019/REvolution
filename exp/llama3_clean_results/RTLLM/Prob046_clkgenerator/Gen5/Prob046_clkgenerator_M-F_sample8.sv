module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0; // Initialize a counter

always #1 begin // Run every 1 time unit to simulate clock generation
    if (counter == (PERIOD / 2 - 1)) begin // If counter reaches half of the period
        clk = ~clk; // Toggle the clock
        counter = 0; // Reset the counter
    end else begin
        counter = counter + 1; // Increment the counter
    end
end

initial begin // Set initial state of the clock
    clk = 0;
end

endmodule