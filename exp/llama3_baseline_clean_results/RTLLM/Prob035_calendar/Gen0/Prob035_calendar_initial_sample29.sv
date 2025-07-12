module calendar(
    input         CLK,    // Clock input
    input         RST,    // Active high reset signal
    output reg [5:0] Secs, // 6-bit output representing the current seconds
    output reg [5:0] Mins, // 6-bit output representing the current minutes
    output reg [4:0] Hours // 5-bit output representing the current hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0; // Reset seconds to 0 when RST is active
    end else if (Secs == 6'b111011) begin // Check if seconds is 59
        Secs <= 6'b0; // Wrap around seconds to 0
    end else begin
        Secs <= Secs + 1; // Increment seconds by 1
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0; // Reset minutes to 0 when RST is active
    end else if (Secs == 6'b111011 && Mins == 6'b111011) begin // Check if minutes and seconds are both 59
        Mins <= 6'b0; // Wrap around minutes to 0
    end else if (Secs == 6'b111011) begin // Check if seconds is 59
        Mins <= Mins + 1; // Increment minutes by 1
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'b0; // Reset hours to 0 when RST is active
    end else if (Mins == 6'b111011 && Secs == 6'b111011 && Hours == 5'b10111) begin // Check if hours, minutes, and seconds are at their maximum
        Hours <= 5'b0; // Wrap around hours to 0
    end else if (Mins == 6'b111011 && Secs == 6'b111011) begin // Check if minutes and seconds are both 59
        Hours <= Hours + 1; // Increment hours by 1
    end
end

endmodule