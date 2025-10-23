module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Total seconds in 12-hour cycle: 0..43199 (12 * 3600 - 1)
reg [15:0] total_seconds;

// Internal signals for hours, minutes, seconds in binary
reg [4:0] hour_bin_0_11; // 0..11 representing hours 12,1..11
reg [5:0] minute_bin;    // 0..59
reg [5:0] second_bin;    // 0..59

// Increment total_seconds on ena, reset to 0 on reset
always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 16'd0;
    end else if (ena) begin
        if (total_seconds == 16'd43199)
            total_seconds <= 16'd0;
        else
            total_seconds <= total_seconds + 16'd1;
    end
end

// Calculate hour_bin_0_11 = (total_seconds / 3600) mod 12
// Calculate minute_bin = (total_seconds / 60) mod 60
// Calculate second_bin = total_seconds mod 60
always @(*) begin
    // integer division approximation by subtraction
    // total_seconds is max 43199
    // calculate hours = total_seconds / 3600
    integer rem, h, m, s;
    rem = total_seconds;
    
    // hours = rem / 3600
    h = 0;
    while (rem >= 3600) begin
        rem = rem - 3600;
        h = h + 1;
    end

    // minutes = rem / 60
    m = 0;
    while (rem >= 60) begin
        rem = rem - 60;
        m = m + 1;
    end

    s = rem;

    hour_bin_0_11 = h % 12;
    minute_bin = m;
    second_bin = s;

    // pm is high if hour >= 6 (12 PM to 11:59:59 PM)
    pm = (h >= 6) ? 1'b1 : 1'b0;
end

// Convert hour_bin_0_11 (0..11) to BCD hh (01..12)
// 0 means 12, else hour_bin_0_11 is hour
function [7:0] hour_to_bcd(input [4:0] h_0_11);
    reg [4:0] hval;
    begin
        hval = (h_0_11 == 0) ? 5'd12 : h_0_11;
        if (hval <= 9)
            hour_to_bcd = {4'd0, hval[3:0]};
        else
            hour_to_bcd = {4'd1, (hval - 5'd10)};
    end
endfunction

// Convert 0..59 binary to BCD (8 bits)
function [7:0] bin_to_bcd_59(input [5:0] val);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = 4'd0;
        units = 4'd0;
        if (val >= 50) begin tens = 4'd5; units = val - 6'd50; end
        else if (val >= 40) begin tens = 4'd4; units = val - 6'd40; end
        else if (val >= 30) begin tens = 4'd3; units = val - 6'd30; end
        else if (val >= 20) begin tens = 4'd2; units = val - 6'd20; end
        else if (val >= 10) begin tens = 4'd1; units = val - 6'd10; end
        else begin tens = 4'd0; units = val; end
        bin_to_bcd_59 = {tens, units};
    end
endfunction

// Update outputs combinationally
always @(*) begin
    hh = hour_to_bcd(hour_bin_0_11);
    mm = bin_to_bcd_59(minute_bin);
    ss = bin_to_bcd_59(second_bin);
    // pm updated in combinational block above
end

endmodule