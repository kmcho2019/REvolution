module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter; // A simple counter to manage the clock period

initial begin
    clk = 1'b0; // Initialize the clock signal low
    counter = 4'd0; // Initialize the counter
end

always begin
    #1; // Delay for 1 time unit
    if (counter == (PERIOD / 2)) begin
        clk = ~clk; // Toggle the clock signal
        counter = 4'd0; // Reset the counter
    end else begin
        counter = counter + 1; // Increment the counter
    end
end

endmodule