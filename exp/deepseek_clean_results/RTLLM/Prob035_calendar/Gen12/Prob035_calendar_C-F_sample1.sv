module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits with zero extension
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;  // Actual max for 5-bit counter

always @(posedge CLK or posedge RST) begin
    // Internal rollover flags
    reg sec_roll, min_roll, hour_roll;
    
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Calculate rollover conditions
        sec_roll = (Secs == SEC_MAX);
        min_roll = sec_roll && (Mins == MIN_MAX);
        hour_roll = min_roll && (Hours[4:0] == HOUR_MAX);
        
        // Update seconds
        Secs <= sec_roll ? 6'd0 : Secs + 6'd1;
        
        // Update minutes only when seconds roll over
        if (sec_roll) begin
            Mins <= min_roll ? 6'd0 : Mins + 6'd1;
        end
        
        // Update hours only when minutes and seconds roll over
        if (min_roll) begin
            Hours <= {1'b0, hour_roll ? 5'd0 : Hours[4:0] + 5'd1};
        end
    end
end

endmodule