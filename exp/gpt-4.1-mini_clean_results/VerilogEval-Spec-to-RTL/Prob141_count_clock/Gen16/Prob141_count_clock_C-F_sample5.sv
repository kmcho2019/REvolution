module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour internal binary counter (1..12)
reg [3:0] hour_bin;

// Signals indicating rollovers
wire sec_rollover;
wire min_rollover;

// Seconds counter: increments on ena
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

assign sec_rollover = ena && (ss_tens == 4'd5) && (ss_units == 4'd9);

// Minutes counter: increments on seconds rollover
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

assign min_rollover = sec_rollover && (mm_tens == 4'd5) && (mm_units == 4'd9);

// Hour counter: increments on minute rollover
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm       <= 1'b0;  // AM at reset
    end else if (min_rollover) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;

        // Toggle pm when hour rolls from 11 to 12
        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Function to convert binary hour (1..12) to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9)
            bin_to_bcd_hour = {4'd0, bin_hour};          // tens=0
        else
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10}; // tens=1
    end
endfunction

// Output combinational assignments
always @(*) begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule