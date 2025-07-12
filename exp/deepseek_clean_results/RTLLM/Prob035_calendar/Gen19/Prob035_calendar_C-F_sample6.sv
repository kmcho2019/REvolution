module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits with MSB=0 (0-23)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// Rollover conditions
wire sec_roll = (Secs == SEC_MAX);
wire min_roll = (Mins == MIN_MAX) & sec_roll;
wire hour_roll = (Hours[4:0] == HOUR_MAX) & min_roll;

// Next state calculations (parallel)
wire [5:0] next_sec = sec_roll ? 6'd0 : (Secs + 6'd1);
wire [5:0] next_min = min_roll ? 6'd0 : (sec_roll ? (Mins + 6'd1) : Mins);
wire [4:0] next_hour = hour_roll ? 5'd0 : (min_roll ? (Hours[4:0] + 5'd1) : Hours[4:0]);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        
        // Only update minutes when seconds roll over
        if (sec_roll) begin
            Mins <= next_min;
            
            // Only update hours when minutes roll over
            if (min_roll) begin
                Hours <= {1'b0, next_hour};
            end
        end
    end
end

endmodule