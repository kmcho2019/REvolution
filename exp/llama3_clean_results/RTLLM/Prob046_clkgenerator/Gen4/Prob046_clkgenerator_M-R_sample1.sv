module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

always @(posedge $global_clock) begin // Assuming a system clock
    counter <= counter + 1; // Increment the counter
    
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk; // Toggle the clock
        counter <= 0; // Reset the counter
    end
end

initial begin
    clk = 0; // Initialize the clock signal
    counter = 0; // Initialize the counter
end

endmodule