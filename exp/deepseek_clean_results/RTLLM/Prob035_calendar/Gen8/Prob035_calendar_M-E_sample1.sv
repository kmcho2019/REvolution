module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next value registers
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour;

// Enable signals (asserted one cycle before rollover)
wire sec_en = 1'b1;  // Always counting
wire min_en = (Secs == 6'd58);
wire hour_en = (Mins == 6'd58) && (Secs == 6'd58);

// Predictive rollover detection
wire sec_roll = (Secs == 6'd59);
wire min_roll = (Mins == 6'd59);
wire hour_roll = (Hours == 5'd23);

// Seconds counter (always updates)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        next_sec <= 6'd1;
    end else begin
        Secs <= next_sec;
        next_sec <= (sec_roll) ? 6'd0 : (next_sec + 6'd1);
    end
end

// Minutes counter (updates only when needed)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
        next_min <= 6'd1;
    end else if (min_en) begin
        Mins <= next_min;
        next_min <= (min_roll && sec_roll) ? 6'd0 : (next_min + 6'd1);
    end
end

// Hours counter (updates least frequently)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        next_hour <= 5'd1;
    end else if (hour_en) begin
        Hours <= next_hour;
        next_hour <= (hour_roll && min_roll && sec_roll) ? 5'd0 : (next_hour + 5'd1);
    end
end

endmodule