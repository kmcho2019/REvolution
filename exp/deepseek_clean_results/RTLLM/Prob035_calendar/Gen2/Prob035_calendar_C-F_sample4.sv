module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Shared terminal count signals
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 6'd23);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end
    else begin
        Secs <= sec_max ? 6'd0 : Secs + 6'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end
    else if (sec_max) begin
        Mins <= (min_max && sec_max) ? 6'd0 : Mins + 6'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end
    else if (sec_max && min_max) begin
        Hours <= (hour_max && min_max && sec_max) ? 6'd0 : Hours + 6'd1;
    end
end

endmodule