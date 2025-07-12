module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Seconds counter: counts 0-59, wraps to 0 every second
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter: increments only when seconds roll over from 59 to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (Secs == 6'd59) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        // no else, hold previous value to reduce toggling
    end

    // Hours counter: increments only when minutes roll over from 59 to 0 and seconds == 59 (i.e., at end of hour)
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end
        // no else, hold previous value
    end

endmodule