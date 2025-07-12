module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter; // A simple counter to manage the clock period

initial begin
    clk = 1'b0; // Initialize the clock signal low
    counter = 32'd0; // Initialize the counter
end

always #1 begin // Use a timing event to increment the counter
    counter = counter + 1; // Increment the counter
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // Toggle the clock signal
        counter = 32'd0; // Reset the counter
    end
end

endmodule