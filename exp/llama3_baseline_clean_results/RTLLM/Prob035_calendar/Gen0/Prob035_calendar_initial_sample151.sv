module calendar(
    input CLK, // Clock input
    input RST, // Active high reset signal
    output reg [5:0] Hours, // 6-bit output representing the current hours
    output reg [5:0] Mins, // 6-bit output representing the current minutes
    output reg [5:0] Secs // 6-bit output representing the current seconds
);

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // If reset signal is active
        Secs <= 6'b0; // Reset seconds to 0
    end else if (Secs == 6'd59) begin // If seconds reach 59
        Secs <= 6'b0; // Wrap around to 0
    end else begin
        Secs <= Secs + 1; // Increment seconds by 1
    end
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // If reset signal is active
        Mins <= 6'b0; // Reset minutes to 0
    end else if (Mins == 6'd59 && Secs == 6'd59) begin // If minutes and seconds reach 59
        Mins <= 6'b0; // Wrap around to 0
    end else if (Secs == 6'd59) begin // If seconds reach 59
        Mins <= Mins + 1; // Increment minutes by 1
    end else begin
        Mins <= Mins; // Keep minutes unchanged
    end
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin // If reset signal is active
        Hours <= 6'b0; // Reset hours to 0
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin // If hours, minutes, and seconds reach their max
        Hours <= 6'b0; // Wrap around to 0
    end else if (Mins == 6'd59 && Secs == 6'd59) begin // If minutes and seconds reach 59
        Hours <= Hours + 1; // Increment hours by 1
    end else begin
        Hours <= Hours; // Keep hours unchanged
    end
end

endmodule