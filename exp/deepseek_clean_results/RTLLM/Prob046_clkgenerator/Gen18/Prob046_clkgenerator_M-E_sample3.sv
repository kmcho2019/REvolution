module clkgenerator #(
    parameter PERIOD = 10,
    parameter JITTER_REDUCTION = 2
)(
    output reg clk = 0
);

    // Internal timing registers
    reg [31:0] main_counter = 0;
    reg [7:0]  delay_chain = 0;
    reg [15:0] period_accum = 0;
    reg [3:0]  fractional = 0;
    
    // Self-calibration registers
    reg [15:0] measured_period = 0;
    reg [15:0] period_error = 0;
    reg        calibrating = 1;
    
    // Main oscillator
    always begin
        // Calculate total delay (counter + fractional)
        main_counter = (PERIOD >> 1) - 1;
        fractional = PERIOD[0] ? 4'b1000 : 4'b0000;
        
        // Wait main counter cycles
        if (main_counter > 0) begin
            repeat (main_counter) @(posedge $sim_clock);
        end
        
        // Apply fractional delay using delay chain
        delay_chain = 0;
        while (delay_chain < fractional) begin
            delay_chain = delay_chain + 1;
            @(posedge $sim_clock);
        end
        
        // Toggle clock with jitter reduction
        if (JITTER_REDUCTION > 0) begin
            period_accum = period_accum + PERIOD;
            if (period_accum >= (PERIOD << JITTER_REDUCTION)) begin
                clk = ~clk;
                period_accum = period_accum - (PERIOD << JITTER_REDUCTION);
            end
        end else begin
            clk = ~clk;
        end
        
        // Self-calibration logic
        if (calibrating) begin
            measured_period = measured_period + 1;
            if (clk) begin
                period_error = PERIOD - measured_period;
                measured_period = 0;
                if (period_error == 0) calibrating = 0;
            end
        end
    end
    
    // Simulation clock for timing reference
    reg $sim_clock = 0;
    always #1 $sim_clock = ~$sim_clock;
    
    // Period monitoring
    initial begin
        $display("[CLKGEN] Starting with target period: %0d", PERIOD);
        forever begin
            @(posedge clk);
            if (!calibrating)
                $display("[CLKGEN] Stable operation at period: %0d", PERIOD);
        end
    end

endmodule