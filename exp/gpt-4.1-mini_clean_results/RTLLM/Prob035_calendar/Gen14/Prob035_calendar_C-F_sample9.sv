module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Seconds counter: counts 0-59, increments every clock cycle, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter: increments when seconds wrap from 59 to 0, counts 0-59, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            Mins <= 6'd0;
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;
        // else no assignment to enable optimization
    end

    // Hours counter: increments when minutes and seconds wrap, counts 0-23, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if ((Hours == 5'd23) && (Mins == 6'd59) && (Secs == 6'd59))
            Hours <= 5'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59))
            Hours <= Hours + 5'd1;
        // else no assignment to enable optimization
    end

endmodule