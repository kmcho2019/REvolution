module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] timer;
reg clk_state;

always @(posedge $global_clock) begin
    // Increment the timer
    timer = timer + 1;
    
    // Check if it's time to toggle the clock
    if (timer == (PERIOD / 2)) begin
        // Toggle the clock state
        clk_state = ~clk_state;
        // Reset the timer
        timer = 0;
    end
    
    // Assign the clock output
    clk = clk_state;
end

initial begin
    // Initialize the clock state and timer
    clk_state = 1'b0;
    timer = 0;
end

endmodule