module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
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
        if ((Secs == 6'd59) && (Mins == 6'd59)) begin
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else begin
        if ((Secs == 6'd59) && (Mins == 6'd59) && (Hours == 6'd23)) begin
            Hours <= 6'd0;
        end else if ((Secs == 6'd59) && (Mins == 6'd59)) begin
            Hours <= Hours + 6'd1;
        end
    end
end

endmodule