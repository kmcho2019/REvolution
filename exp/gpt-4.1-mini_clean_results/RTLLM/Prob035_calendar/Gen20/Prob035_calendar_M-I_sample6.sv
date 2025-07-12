module calendar (
    input  wire       CLK,
    input  wire       RST,    // synchronous active high reset
    output reg  [5:0] Hours,  // output 6-bit as requested (0-23 used)
    output reg  [5:0] Mins,   // 6 bits (0-59)
    output reg  [5:0] Secs    // 6 bits (0-59)
);

// Synchronous reset and simple second counter
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

// Minute counter enabled only when seconds wrap around
always @(posedge CLK) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
    // else retain previous value (no else branch needed, reg holds)
end

// Hour counter enabled only when minutes and seconds wrap around
always @(posedge CLK) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
    // else retain previous value
end

endmodule