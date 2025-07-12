module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Seconds counter: increments every clock, wraps at 59
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter: increments when seconds wrap from 59 to 0, wraps at 59
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            Mins <= 6'd0;
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;
        // else no assignment to minimize toggling
    end

    // Hours counter: increments when minutes and seconds wrap, wraps at 23
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if ((Hours == 5'd23) && (Mins == 6'd59) && (Secs == 6'd59))
            Hours <= 5'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            Hours <= Hours + 5'd1;
        // else no assignment to minimize toggling
    end

endmodule