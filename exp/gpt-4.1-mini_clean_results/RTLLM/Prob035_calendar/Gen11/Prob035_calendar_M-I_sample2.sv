module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Secs   // 0-59
);

// Increment seconds every clock cycle
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

// Increment minutes when seconds wrap around (Secs==59 -> next cycle Secs=0)
wire sec_wrap = (Secs == 6'd59);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_wrap) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end else begin
        // Retain previous value (no toggling)
        Mins <= Mins;
    end
end

// Increment hours when minutes wrap (Mins==59) and seconds wrap (sec_wrap)
wire min_wrap = (Mins == 6'd59);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (sec_wrap && min_wrap) begin
        if (Hours == 5'd23)
            Hours <= 5'd0;
        else
            Hours <= Hours + 5'd1;
    end else begin
        // Retain previous value (no toggling)
        Hours <= Hours;
    end
end

endmodule