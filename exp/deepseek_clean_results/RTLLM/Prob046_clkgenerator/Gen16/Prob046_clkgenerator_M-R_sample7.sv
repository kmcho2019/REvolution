module clkgenerator #(
    parameter PERIOD = 10,
    parameter DUTY_CYCLE = 50  // percentage (50% for square wave)
)(
    output reg clk
);

    // Calculate high and low periods based on duty cycle
    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;
    
    reg [31:0] counter = 0;
    
    initial begin
        clk = 1'b0;  // Initialize clock to 0 as specified
    end
    
    always begin
        // Wait for half of high time (rising edge)
        #(HIGH_TIME / 2);
        clk = 1'b1;
        
        // Wait for remaining high time + half of low time (falling edge)
        #((HIGH_TIME / 2) + (LOW_TIME / 2));
        clk = 1'b0;
        
        // Wait for remaining low time to complete period
        #(LOW_TIME / 2);
    end

endmodule