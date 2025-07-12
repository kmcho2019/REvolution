module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Seconds counter: counts 0-59, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter enable signal: increment only when seconds roll over
    wire mins_inc_en = (Secs == 6'd59);

    // Minutes counter: increments when seconds wrap from 59 to 0, counts 0-59, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (mins_inc_en) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        // else no assignment for power optimization
    end

    // Hours counter enable signal: increment only when minutes and seconds wrap
    wire hours_inc_en = (Mins == 6'd59) && (Secs == 6'd59);

    // Hours counter: increments when minutes and seconds wrap, counts 0-23, wraps to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if (hours_inc_en) begin
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end
        // else no assignment for power optimization
    end

endmodule