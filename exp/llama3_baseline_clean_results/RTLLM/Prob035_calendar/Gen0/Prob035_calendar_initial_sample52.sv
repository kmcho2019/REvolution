module calendar(
    input         CLK,  // Clock input
    input         RST,  // Active high reset signal
    output reg [5:0] Hours,  // 6-bit output representing the current hours
    output reg [5:0] Mins,   // 6-bit output representing the current minutes
    output reg [5:0] Secs    // 6-bit output representing the current seconds
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;  // Reset seconds to 0 on active high reset
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;  // Wrap around seconds to 0 when it reaches 59
    end else begin
        Secs <= Secs + 1;  // Increment seconds by 1
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;  // Reset minutes to 0 on active high reset
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 6'd0;  // Wrap around minutes to 0 when both minutes and seconds are 59
    end else if (Secs == 6'd59) begin
        Mins <= Mins + 1;  // Increment minutes by 1 when seconds is 59
    end else begin
        Mins <= Mins;  // Keep minutes unchanged
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;  // Reset hours to 0 on active high reset
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'd0;  // Wrap around hours to 0 when hours, minutes, and seconds are all at their maximum
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 1;  // Increment hours by 1 when minutes and seconds are both 59
    end else begin
        Hours <= Hours;  // Keep hours unchanged
    end
end

endmodule