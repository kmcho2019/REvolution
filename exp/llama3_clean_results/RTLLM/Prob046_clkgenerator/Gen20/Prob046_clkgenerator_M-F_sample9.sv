module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

// Define a counter to track time
reg [3:0] counter;

// Initialize the clock and counter
initial begin
    clk = 1'b0;
    counter = 4'd0;
end

// Increment the counter every clock cycle (not dependent on the output clock)
always @(posedge $global_clock) begin
    counter <= counter + 1'b1;
    
    // Toggle the clock when half the period is reached and reset the counter
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 4'd0;
    end
end

endmodule