module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter;

initial begin
    counter = 0; // Initialize the counter
    clk = 0; // Initialize the clock signal
end

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // Toggle the clock signal
        counter = 0; // Reset the counter
    end
end

always #1 begin
    counter = counter + 1; // Increment the counter
end

endmodule