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
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        // Increment minute only when seconds roll over from 59 to 0
        if ((Secs == 6'd59)) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Mins <= Mins; // Hold value otherwise
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        // Increment hour only when minutes and seconds roll over
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 6'd23) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end else begin
            Hours <= Hours; // Hold value otherwise
        end
    end
end

endmodule