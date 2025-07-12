module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes (registered)
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; // 1..12

// Flags for increments
wire sec_rollover;
wire min_rollover;
wire hour_inc;
wire hour_roll_11_to_12;

// Increment seconds BCD digits on ena
always @(posedge clk) begin
    if (reset) begin
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
    end else if (ena) begin
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5)
                ss_tens <= 4'd0;
            else
                ss_tens <= ss_tens + 4'd1;
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

assign sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

// Increment minutes BCD digits on seconds rollover
always @(posedge clk) begin
    if (reset) begin
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (sec_rollover) begin
        if (mm_units == 4'd9) begin
            mm_units <= 4'd0;
            if (mm_tens == 4'd5)
                mm_tens <= 4'd0;
            else
                mm_tens <= mm_tens + 4'd1;
        end else begin
            mm_units <= mm_units + 4'd1;
        end
    end
end

assign min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9) && sec_rollover;

// Increment hour counter on minute rollover
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;  // 12-hour format, start at 12
        pm       <= 1'b0;   // AM
    end else if (min_rollover) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;
        // Toggle pm only when hour increments from 11 to 12
        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Combinational function to convert binary hour (1..12) to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9) begin
            bin_to_bcd_hour = {4'd0, bin_hour};
        end else begin
            // 10 to 12
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    end
endfunction

// Output logic: combine BCD digits into 8-bit outputs
always @(*) begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule