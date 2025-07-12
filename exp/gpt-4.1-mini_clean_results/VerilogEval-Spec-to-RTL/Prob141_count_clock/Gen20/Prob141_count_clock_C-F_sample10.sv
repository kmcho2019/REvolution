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

// Internal binary hour counter (1..12)
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

// Hour counter: increments on minute rollover, toggle pm on 11->12
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm       <= 1'b0; // AM at reset
    end else if (min_rollover) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;

        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Optimized function: binary hour (1..12) to BCD (two digits)
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        case (bin_hour)
            4'd1:  bin_to_bcd_hour = 8'h01;
            4'd2:  bin_to_bcd_hour = 8'h02;
            4'd3:  bin_to_bcd_hour = 8'h03;
            4'd4:  bin_to_bcd_hour = 8'h04;
            4'd5:  bin_to_bcd_hour = 8'h05;
            4'd6:  bin_to_bcd_hour = 8'h06;
            4'd7:  bin_to_bcd_hour = 8'h07;
            4'd8:  bin_to_bcd_hour = 8'h08;
            4'd9:  bin_to_bcd_hour = 8'h09;
            4'd10: bin_to_bcd_hour = 8'h10;
            4'd11: bin_to_bcd_hour = 8'h11;
            4'd12: bin_to_bcd_hour = 8'h12;
            default: bin_to_bcd_hour = 8'h00; // shouldn't occur
        endcase
    end
endfunction

// Combinational output assignments
always @(*) begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule