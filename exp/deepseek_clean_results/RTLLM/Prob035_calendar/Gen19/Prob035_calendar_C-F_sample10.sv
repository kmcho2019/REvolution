module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
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
wire hour_roll = (Hours == HOUR_MAX) & min_roll;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Update seconds
        if (sec_roll)
            Secs <= 6'd0;
        else
            Secs <= Secs + 1;
        
        // Update minutes only when seconds roll over
        if (sec_roll) begin
            if (min_roll)
                Mins <= 6'd0;
            else
                Mins <= Mins + 1;
        end
        
        // Update hours only when minutes roll over
        if (min_roll & sec_roll) begin
            if (hour_roll)
                Hours <= 5'd0;
            else
                Hours <= Hours + 1;
        end
    end
end

endmodule