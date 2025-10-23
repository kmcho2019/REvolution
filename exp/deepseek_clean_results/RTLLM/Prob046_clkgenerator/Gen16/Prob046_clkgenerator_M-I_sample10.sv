module clkgenerator #(
    parameter PERIOD = 10,          // Clock period in time units
    parameter DUTY_CYCLE = 50       // Duty cycle percentage (50% for square wave)
)(
    output reg clk = 0              // Initialize clock to 0
);

    // Calculate high and low periods
    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE + 50) / 100;  // Round properly
    localparam LOW_TIME = PERIOD - HIGH_TIME;
    
    // Determine optimal counter width
    localparam COUNTER_WIDTH = $clog2(PERIOD);
    reg [COUNTER_WIDTH-1:0] counter = 0;
    
    always @(counter) begin
        if (counter < HIGH_TIME)
            clk <= 1'b1;
        else
            clk <= 1'b0;
    end
    
    always begin
        // Wait for half of the time unit for better edge alignment
        #((PERIOD)/2.0);
        counter <= (counter == PERIOD - 1) ? 0 : counter + 1;
    end

endmodule