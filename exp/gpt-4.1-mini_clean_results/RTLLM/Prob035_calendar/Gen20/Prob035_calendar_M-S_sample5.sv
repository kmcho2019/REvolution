module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,  // Using 6 bits as requested
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Maximum values for counters
    localparam HOURS_MAX = 6'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == SECS_MAX)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (Mins == MINS_MAX && Secs == SECS_MAX)
            Mins <= 6'd0;
        else if (Secs == SECS_MAX)
            Mins <= Mins + 6'd1;
        else
            Mins <= Mins;
    end

    // Hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 6'd0;
        else if (Hours == HOURS_MAX && Mins == MINS_MAX && Secs == SECS_MAX)
            Hours <= 6'd0;
        else if (Mins == MINS_MAX && Secs == SECS_MAX)
            Hours <= Hours + 6'd1;
        else
            Hours <= Hours;
    end

endmodule