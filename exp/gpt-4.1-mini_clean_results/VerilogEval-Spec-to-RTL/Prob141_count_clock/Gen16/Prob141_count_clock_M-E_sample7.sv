module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Hours: two BCD digits (01..12)
reg [3:0] hh_tens;
reg [3:0] hh_units;

// Minutes: two BCD digits (00..59)
reg [3:0] mm_tens;
reg [3:0] mm_units;

// Seconds: two BCD digits (00..59)
reg [3:0] ss_tens;
reg [3:0] ss_units;

// Internal signals for rollover detection
wire sec_rollover;
wire min_rollover;
wire hour_rollover;

// Combinational logic to increment seconds BCD
// Returns the next BCD digit and indicates if rollover occurred
function automatic [4:0] inc_bcd_digit(input [3:0] digit, input [3:0] max);
    reg [4:0] result; // 4 bits + carry flag
    begin
        if (digit == max) begin
            result = {1'b1, 4'd0}; // rollover with carry out
        end else begin
            result = {1'b0, digit + 4'd1};
        end
        inc_bcd_digit = result;
    end
endfunction

// Increment seconds on ena
wire [4:0] next_ss_units_w, next_ss_tens_w;
assign next_ss_units_w = inc_bcd_digit(ss_units, 4'd9);
assign next_ss_tens_w  = (next_ss_units_w[4]) ? inc_bcd_digit(ss_tens, 4'd5) : {1'b0, ss_tens};
assign sec_rollover    = next_ss_units_w[4] && next_ss_tens_w[4];

// Increment minutes on seconds rollover
wire [4:0] next_mm_units_w, next_mm_tens_w;
assign next_mm_units_w = inc_bcd_digit(mm_units, 4'd9);
assign next_mm_tens_w  = (next_mm_units_w[4]) ? inc_bcd_digit(mm_tens, 4'd5) : {1'b0, mm_tens};
assign min_rollover    = next_mm_units_w[4] && next_mm_tens_w[4];

// Increment hours on minutes rollover
// Hours go from 01 to 12 (BCD)
reg [7:0] next_hh;
reg       next_pm;

always @* begin
    next_hh = {hh_tens, hh_units};
    next_pm = pm;

    if (min_rollover) begin
        if (hh_tens == 4'd0 && hh_units == 4'd9) begin
            // from 09 to 10
            next_hh = 8'h10;
        end else if (hh_tens == 4'd1 && hh_units == 4'd2) begin
            // from 12 to 01 with pm toggle
            next_hh = 8'h01;
            next_pm = ~pm;
        end else if (hh_tens == 4'd1 && hh_units < 4'd2) begin
            // increment units digit (10 or 11)
            next_hh = {4'd1, hh_units + 4'd1};
        end else if (hh_tens == 4'd0) begin
            // increment units digit (01..08)
            next_hh = {4'd0, hh_units + 4'd1};
        end else begin
            // default: hold value (should not occur)
            next_hh = {hh_tens, hh_units};
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2;
        hh_tens  <= 4'd1;
        pm       <= 1'b0; // AM
    end else if (ena) begin
        // Update seconds
        ss_units <= next_ss_units_w[3:0];
        ss_tens  <= next_ss_tens_w[3:0];

        // Update minutes on second rollover
        if (sec_rollover) begin
            mm_units <= next_mm_units_w[3:0];
            mm_tens  <= next_mm_tens_w[3:0];
        end

        // Update hours and pm on minute rollover
        if (min_rollover) begin
            hh_tens  <= next_hh[7:4];
            hh_units <= next_hh[3:0];
            pm       <= next_pm;
        end
    end
end

// Output assignments
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule