module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter; // Counter for clock signal generation

initial begin
    clk = 0; // Initial state of the clock signal
    counter = 0; // Initial state of the counter
end

always @(posedge clk or negedge clk) begin
    if (counter == (PERIOD / 2)) begin // Check if half period has passed
        clk = ~clk; // Toggle clock signal
        counter = 0; // Reset counter
    end else begin
        counter = counter + 1; // Increment counter
    end
end

endmodule