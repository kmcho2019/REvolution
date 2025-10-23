module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Binary counters
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12

// Increment seconds on ena
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
    end else if (ena) begin
        if (seconds == 6'd59)
            seconds <= 6'd0;
        else
            seconds <= seconds + 6'd1;
    end
end

// Increment minutes when seconds roll over
wire sec_rollover = (ena && seconds == 6'd59);
always @(posedge clk) begin
    if (reset) begin
        minutes <= 6'd0;
    end else if (sec_rollover) begin
        if (minutes == 6'd59)
            minutes <= 6'd0;
        else
            minutes <= minutes + 6'd1;
    end
end

// Increment hours when minutes roll over
wire min_rollover = (sec_rollover && (minutes == 6'd59));
reg prev_hour_11; // track previous hour == 11 for PM toggle

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd12;
        pm <= 1'b0;
        prev_hour_11 <= 1'b0;
    end else begin
        prev_hour_11 <= (hours == 4'd11);
        if (min_rollover) begin
            if (hours == 4'd11) begin
                hours <= 4'd12;
                pm <= ~pm; // toggle pm on 11->12
            end else if (hours == 4'd12) begin
                hours <= 4'd1;
            end else begin
                hours <= hours + 4'd1;
            end
        end
    end
end

// Binary to BCD conversion for 0-59 using combinational logic
// Efficient double-dabble method for 6 bits

function [7:0] bin_to_bcd_60;
    input [5:0] bin;
    reg [7:0] bcd; // {tens, units}
    reg [5:0] i;
    reg [11:0] shift; // 12 bits to hold 2 BCD digits + 6 bits input
begin
    shift = {6'd0, bin}; // initialize with binary input in low bits
    // 6 cycles to process each binary bit
    for (i=0; i<6; i=i+1) begin
        // Add 3 if any BCD digit is >= 5
        if (shift[11:8] >= 4'd5)
            shift[11:8] = shift[11:8] + 4'd3;
        if (shift[7:4] >= 4'd5)
            shift[7:4] = shift[7:4] + 4'd3;
        // Shift left by 1
        shift = shift << 1;
    end
    bcd = {shift[11:8], shift[7:4]};
    bin_to_bcd_60 = bcd;
end
endfunction

// Hours BCD output from 1 to 12 by LUT
// Since hours = 1..12, output tens and units directly
function [7:0] bin_to_bcd_12;
    input [3:0] bin;
    reg [3:0] tens;
    reg [3:0] units;
begin
    case (bin)
        4'd1:  begin tens=4'd0; units=4'd1; end
        4'd2:  begin tens=4'd0; units=4'd2; end
        4'd3:  begin tens=4'd0; units=4'd3; end
        4'd4:  begin tens=4'd0; units=4'd4; end
        4'd5:  begin tens=4'd0; units=4'd5; end
        4'd6:  begin tens=4'd0; units=4'd6; end
        4'd7:  begin tens=4'd0; units=4'd7; end
        4'd8:  begin tens=4'd0; units=4'd8; end
        4'd9:  begin tens=4'd0; units=4'd9; end
        4'd10: begin tens=4'd1; units=4'd0; end
        4'd11: begin tens=4'd1; units=4'd1; end
        4'd12: begin tens=4'd1; units=4'd2; end
        default: begin tens=4'd0; units=4'd0; end
    endcase
    bin_to_bcd_12 = {tens, units};
end
endfunction

// Outputs assign
assign ss = bin_to_bcd_60(seconds);
assign mm = bin_to_bcd_60(minutes);
assign hh = bin_to_bcd_12(hours);

endmodule