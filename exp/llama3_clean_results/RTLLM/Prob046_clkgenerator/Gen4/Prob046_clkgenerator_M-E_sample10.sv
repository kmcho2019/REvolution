module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [7:0] counter; // Counter to track time
reg clk_int; // Internal clock signal
reg half_period; // Half of the specified period

initial begin
    counter = 0; // Initialize counter
    half_period = (PERIOD / 2); // Calculate half period
    clk_int = 1'b0; // Initialize clock to 0
end

always @(posedge $global_clock) begin // Assuming a global clock for simplicity
    if (counter == half_period) begin
        clk_int <= ~clk_int; // Toggle clock at half period
        counter <= 0; // Reset counter
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

assign clk = clk_int; // Assign internal clock to output

endmodule