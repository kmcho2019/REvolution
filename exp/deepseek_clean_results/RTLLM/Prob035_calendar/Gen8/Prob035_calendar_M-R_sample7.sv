module calendar(
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Overflow signals
wire sec_overflow = (Secs == 6'd59);
wire min_overflow = (Mins == 6'd59) & sec_overflow;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (sec_overflow) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter (enabled by seconds overflow)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_overflow) begin
        if (min_overflow) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter (enabled by minutes overflow)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (min_overflow & sec_overflow) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours + 5'd1;
        end
    end
end

endmodule