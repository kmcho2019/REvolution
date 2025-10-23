module clkgenerator #(
    parameter PERIOD = 10,
    parameter DUTY = 50    // Duty cycle percentage (0-100)
) (
    output reg clk,
    input enable = 1'b1,    // Optional clock enable
    input reset = 1'b0      // Synchronous reset
);

    localparam HIGH_TIME = (PERIOD * DUTY) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;
    
    reg [$clog2(PERIOD)-1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk <= 1'b0;
        end
        else if (enable) begin
            counter <= (counter == PERIOD-1) ? 0 : counter + 1;
            
            // Generate clock edges
            if (counter == 0) clk <= 1'b1;
            else if (counter == HIGH_TIME) clk <= 1'b0;
        end
    end

    // Initialization for simulation
    initial begin
        counter = 0;
        clk = 1'b0;
    end

endmodule