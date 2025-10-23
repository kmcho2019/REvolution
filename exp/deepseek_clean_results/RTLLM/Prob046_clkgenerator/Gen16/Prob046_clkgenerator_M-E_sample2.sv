module clkgenerator #(
    parameter PERIOD = 10,         // Clock period in time units
    parameter JITTER = 0,          // Optional clock jitter (0-10% of period)
    parameter PHASE = 0,           // Initial phase offset (0-360 degrees)
    parameter ENABLE = 1           // Initial enable state
)(
    output reg clk = 0            // Generated clock output
);

    realtime phase_delay;
    realtime half_period;
    realtime jitter_value;
    realtime next_edge;

    // Calculate timing parameters
    initial begin
        half_period = PERIOD / 2.0;
        phase_delay = (PHASE * PERIOD) / 360.0;
        
        if (ENABLE) begin
            #phase_delay;
            clock_loop();
        end
    end

    // Main clock generation loop
    task clock_loop;
        forever begin
            // Calculate jitter for this cycle (if enabled)
            jitter_value = ($urandom%JITTER) * PERIOD / 1000.0;
            
            // Generate rising edge
            clk = 1'b1;
            next_edge = half_period + jitter_value;
            #next_edge;
            
            // Calculate jitter for falling edge
            jitter_value = ($urandom%JITTER) * PERIOD / 1000.0;
            
            // Generate falling edge
            clk = 1'b0;
            next_edge = half_period + jitter_value;
            #next_edge;
        end
    endtask

    // Control interface
    task enable;
        input state;
        begin
            if (state && !ENABLE) begin
                ENABLE = 1;
                #phase_delay;
                clock_loop();
            end
            else if (!state && ENABLE) begin
                ENABLE = 0;
                disable clock_loop;
                clk = 1'b0;
            end
        end
    endtask

    // Period verification
    initial begin
        #(PERIOD * 10);
        $display("[CLKGEN] Period check: Nominal=%0t, Actual=%0t", 
                 PERIOD, $realtime/10);
    end

endmodule