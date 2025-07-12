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
    
    always @(*) begin
        if (counter < HIGH_TIME)
            clk = 1'b1;
        else
            clk = 1'b0;
    end
    
    always begin
        #1;  // simulation time precision
        counter = (counter == PERIOD - 1) ? 0 : counter + 1;
    end

endmodule