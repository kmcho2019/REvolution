module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,   // 0-59
    output reg  [5:0] Mins,   // 0-59
    output reg  [5:0] Hours   // 0-23 fits in 6 bits, using 6 bits for uniformity
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
    end else if (Secs == 6'd59) begin
        // Increment minutes on seconds wrapping from 59 to 0 next clock cycle
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
    // else maintain current Mins value
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        // Increment hours when both minutes and seconds wrap next cycle
        if (Hours == 6'd23) begin
            Hours <= 6'd0;
        end else begin
            Hours <= Hours + 6'd1;
        end
    end
    // else maintain current Hours value
end

endmodule