module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 fits in 5 bits
    output reg [5:0] Mins,   // 0-59 needs 6 bits
    output reg [5:0] Secs    // 0-59 needs 6 bits
);

// Seconds counter
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter
always @(posedge CLK) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (Secs == 6'd59 && Mins == 6'd59) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
end

endmodule