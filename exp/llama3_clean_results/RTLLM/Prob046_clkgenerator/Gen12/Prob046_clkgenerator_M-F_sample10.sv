module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter; // Counter variable

initial begin
    clk = 0; // Initialize clock signal to 0
    counter = 0; // Initialize counter to 0
end

always begin
    #1; // Wait for 1 time unit
    if (counter == (PERIOD / 2 - 1)) begin
        clk = ~clk; // Toggle clock signal
        counter = 0; // Reset counter
    end else begin
        counter = counter + 1; // Increment counter
    end
end

endmodule