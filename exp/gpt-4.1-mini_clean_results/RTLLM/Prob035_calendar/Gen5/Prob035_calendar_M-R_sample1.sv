module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,
    output reg  [5:0] Mins,
    output reg  [5:0] Hours
);

    // Seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end

    // Minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
    end

    // Hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if (Secs == 6'd59 && Mins == 6'd59) begin
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end
    end

endmodule