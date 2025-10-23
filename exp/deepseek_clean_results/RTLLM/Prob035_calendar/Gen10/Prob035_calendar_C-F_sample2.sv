module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants for better maintainability
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

always @(posedge CLK or posedge RST) begin
    // Internal rollover conditions (calculated once per relevant cycle)
    reg sec_roll, min_roll, hour_roll;
    reg [5:0] next_sec;
    reg [5:0] next_min;
    reg [4:0] next_hour;

    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Calculate rollover conditions
        sec_roll = (Secs == SEC_MAX);
        min_roll = sec_roll && (Mins == MIN_MAX);
        hour_roll = min_roll && (Hours == HOUR_MAX);

        // Calculate next values
        next_sec = sec_roll ? 6'd0 : (Secs + 6'd1);
        
        if (sec_roll) begin
            next_min = min_roll ? 6'd0 : (Mins + 6'd1);
        end else begin
            next_min = Mins;
        end

        if (min_roll) begin
            next_hour = hour_roll ? 5'd0 : (Hours + 5'd1);
        end else begin
            next_hour = Hours;
        end

        // Update registers
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule