module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(counter) begin
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk; // Toggle the clock signal
    end
    
    if (counter == PERIOD - 1) begin
        counter <= 0; // Reset the counter
    end else begin
        counter <= counter + 1; // Increment the counter
    end
end

initial begin
    clk = 0; // Initialize the clock signal
end

endmodule