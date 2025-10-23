module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Total seconds in a day: 24*60*60 = 86400 (17 bits)
reg [16:0] total_seconds;

// Constants for division
localparam SECONDS_PER_HOUR = 3600;
localparam SECONDS_PER_MINUTE = 60;

// Decoded values
wire [5:0] decoded_hours;
wire [5:0] decoded_mins;
wire [5:0] decoded_secs;

// Main counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 17'd0;
    end else begin
        if (total_seconds == 17'd86399)  // 24*60*60 - 1
            total_seconds <= 17'd0;
        else
            total_seconds <= total_seconds + 1;
    end
end

// Decode logic (combinational)
assign decoded_hours = total_seconds / SECONDS_PER_HOUR;
assign decoded_mins = (total_seconds % SECONDS_PER_HOUR) / SECONDS_PER_MINUTE;
assign decoded_secs = total_seconds % SECONDS_PER_MINUTE;

// Output registers for clean timing
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Hours <= decoded_hours;
        Mins <= decoded_mins;
        Secs <= decoded_secs;
    end
end

endmodule