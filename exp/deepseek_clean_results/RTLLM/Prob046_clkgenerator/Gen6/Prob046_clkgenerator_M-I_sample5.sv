module clkgenerator #(
    parameter PERIOD = 10,          // Clock period in time units
    parameter DUTY_CYCLE = 50,      // Duty cycle percentage (1-99)
    parameter JITTER = 0            // Random jitter amount (0 for no jitter)
) (
    output reg clk = 0,
    input wire reset = 0            // Optional active-high reset
);

    // Calculate high and low times based on duty cycle
    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;

    // Parameter validation
    initial begin
        if (PERIOD < 2) begin
            $warning("PERIOD should be at least 2 for proper operation");
        end
        if (DUTY_CYCLE < 1 || DUTY_CYCLE > 99) begin
            $warning("DUTY_CYCLE should be between 1 and 99");
        end
    end

    // Clock generation with optional reset
    always begin
        if (reset) begin
            clk = 0;
            #(PERIOD);  // Wait full period during reset
        end else begin
            clk = 1;
            #(HIGH_TIME + ($random % (2*JITTER+1)) - JITTER);
            clk = 0;
            #(LOW_TIME + ($random % (2*JITTER+1)) - JITTER);
        end
    end
endmodule