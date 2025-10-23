module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Seconds counter: counts 0 to 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else begin
            if (Secs == 6'd59)
                Secs <= 6'd0;
            else
                Secs <= Secs + 6'd1;
        end
    end

    // Minutes counter: increments when seconds wrap from 59 to 0, counts 0 to 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else begin
            // Increment minute only if seconds wrapped to 0 this cycle
            if (Secs == 6'd59) begin
                if (Mins == 6'd59)
                    Mins <= 6'd0;
                else
                    Mins <= Mins + 6'd1;
            end else begin
                Mins <= Mins; // Hold current value
            end
        end
    end

    // Hours counter: increments when both minutes and seconds wrap to 0, counts 0 to 23
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else begin
            // Increment hour only if minutes and seconds wrapped to 0 this cycle
            if ((Mins == 6'd59) && (Secs == 6'd59)) begin
                if (Hours == 6'd23)
                    Hours <= 6'd0;
                else
                    Hours <= Hours + 6'd1;
            end else begin
                Hours <= Hours; // Hold current value
            end
        end
    end

endmodule