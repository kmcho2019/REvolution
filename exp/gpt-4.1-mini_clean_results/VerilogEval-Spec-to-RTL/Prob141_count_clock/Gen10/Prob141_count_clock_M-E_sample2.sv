module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [4:0] hours;   // 0-23, 0 = 12 AM, 12 = 12 PM

// Increment logic
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 5'd0;   // 12 AM internally represented as 0
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 5'd23)
                    hours <= 5'd0;
                else
                    hours <= hours + 5'd1;
            end else begin
                minutes <= minutes + 6'd1;
            end
        end else begin
            seconds <= seconds + 6'd1;
        end
    end
end

// PM output assignment (PM if hours >= 12)
always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;
    end else if (ena) begin
        pm <= (hours >= 5'd12);
    end
end

// Function to convert binary 0-59 to BCD 8-bit (tens[7:4], units[3:0])
function [7:0] bin_to_bcd_60;
    input [5:0] bin; // 0-59
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = bin / 6'd10;
        units = bin % 6'd10;
        bin_to_bcd_60 = {tens, units};
    end
endfunction

// Function to convert binary hour (0-23) to 12-hour BCD 8-bit output (tens[7:4], units[3:0])
function [7:0] bin_to_12h_bcd;
    input [4:0] hr; // 0-23
    reg [3:0] hour_12;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        // Convert 24h to 12h format:
        // 0 -> 12 AM, 1->1, ..., 11->11 AM, 12->12 PM, 13->1 PM, ..., 23->11 PM
        if (hr == 0)
            hour_12 = 4'd12;
        else if (hr <= 12)
            hour_12 = hr[3:0];
        else
            hour_12 = hr - 5'd12;

        tens  = (hour_12 >= 10) ? 4'd1 : 4'd0;
        units = (hour_12 >= 10) ? (hour_12 - 4'd10) : hour_12;
        bin_to_12h_bcd = {tens, units};
    end
endfunction

// Output combinational logic
always @(*) begin
    hh = bin_to_12h_bcd(hours);
    mm = bin_to_bcd_60(minutes);
    ss = bin_to_bcd_60(seconds);
end

endmodule