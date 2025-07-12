module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] counter; // Narrower counter to save area

initial begin
    counter = 0; // Initialize the counter
    clk = 0; // Initialize the clock signal
end

always #1 begin // System clock drives the counter and clock generation
    if (counter == (PERIOD / 2 - 1)) begin // Toggle condition
        clk = ~clk; // Toggle the clock signal
        counter = 0; // Reset the counter
    end else begin
        counter = counter + 1; // Increment the counter
    end
end

endmodule