module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // History tracking
    reg [7:0] prev_in [0:1];  // Two-cycle history
    reg activity_flag;
    
    // Watchdog counter (checks all bits periodically)
    reg [3:0] watchdog_cnt;
    
    // Edge detection logic
    always @(posedge clk) begin
        // Shift history register
        prev_in[1] <= prev_in[0];
        prev_in[0] <= in;
        
        // Activity detection (OR of all bit changes)
        activity_flag <= (in != prev_in[0]);
        
        // Watchdog counter (every 16 cycles)
        watchdog_cnt <= watchdog_cnt + 1;
        
        // Edge detection (only when activity or watchdog timeout)
        if (activity_flag || (&watchdog_cnt)) begin
            anyedge <= (prev_in[0] ^ prev_in[1]) |  // Normal edge detection
                      (in ^ prev_in[0]);           // Catch single-cycle pulses
        end else begin
            anyedge <= 8'b0;  // Power saving when no activity
        end
    end

endmodule