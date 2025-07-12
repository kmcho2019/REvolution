module clkgenerator #(
    parameter INITIAL_PERIOD = 10,    // Initial clock period
    parameter MAX_PERIOD_DRIFT = 1     // Maximum allowed period drift
)(
    output reg clk = 0,               // Generated clock output
    input wire [15:0] period_adj = 0,  // Dynamic period adjustment
    input wire sync = 0               // External sync pulse
);

    // Internal timing control registers
    reg [31:0] counter = 0;
    reg [31:0] period = INITIAL_PERIOD;
    reg [31:0] half_period = INITIAL_PERIOD/2;
    reg [31:0] phase_error = 0;
    reg [31:0] period_error = 0;
    reg sync_detected = 0;

    // Main clock generation
    always begin
        // Calculate next edge with error correction
        counter = half_period + period_error;
        
        // Wait for half period with dynamic adjustment
        repeat (counter) @(posedge $global_clock);
        
        // Toggle clock
        clk = ~clk;
        
        // Period calibration logic
        if (clk) begin
            // Measure actual period and adjust
            period_error = (period - INITIAL_PERIOD + period_adj) >> 2;
            
            // Constrain period drift
            if (period_error > MAX_PERIOD_DRIFT)
                period_error = MAX_PERIOD_DRIFT;
            else if (period_error < -MAX_PERIOD_DRIFT)
                period_error = -MAX_PERIOD_DRIFT;
            
            // Update half period
            half_period = (period + period_error) >> 1;
        end
        
        // Phase synchronization
        if (sync && !sync_detected) begin
            sync_detected = 1;
            clk = 1'b1;  // Force alignment to sync pulse
            phase_error = 0;
        end else begin
            sync_detected = 0;
        end
    end

    // Virtual global clock for simulation
    reg $global_clock = 0;
    always #1 $global_clock = ~$global_clock;

    // Period monitoring
    initial begin
        forever begin
            @(posedge clk);
            $display("[CLKGEN] Current period: %0d (adjusted by %0d)", 
                     period, period_adj);
        end
    end

endmodule