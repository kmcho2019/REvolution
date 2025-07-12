module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(posedge counter) begin
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // Toggle the clock signal
        counter = 0; // Reset the counter
    end else begin
        counter = counter + 1; // Increment the counter
    end
end

initial begin
    clk = 0; // Initialize the clock signal
    counter = 1; // Initialize the counter to start the always block
end

always #1 counter = counter + 1; // Increment the counter every time unit

endmodule