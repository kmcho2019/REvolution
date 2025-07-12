module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Combinational logic to increment BCD (0x00 to 0x59) for seconds and minutes
wire ss_rollover;
wire [7:0] ss_next;
wire mm_rollover;
wire [7:0] mm_next;
wire hour_rollover;
wire [7:0] hh_next;
wire pm_toggle;

// Increment seconds (BCD 00 to 59)
assign ss_rollover = (ss == 8'h59);
assign ss_next = (ss_rollover) ? 8'h00 :
                 ((ss[3:0] == 4'd9) ? {ss[7:4]+4'd1, 4'd0} : {ss[7:4], ss[3:0]+4'd1});

// Increment minutes if seconds rollover
assign mm_rollover = (mm == 8'h59);
assign mm_next = (ss_rollover) ? 
                 ((mm_rollover) ? 8'h00 : 
                   ((mm[3:0] == 4'd9) ? {mm[7:4]+4'd1,4'd0} : {mm[7:4], mm[3:0]+4'd1}))
                 : mm;

// Helper function: check if hour is 11 (BCD 0x11)
wire is_11 = (hh == 8'h11);
// Helper function: check if hour is 12 (BCD 0x12)
wire is_12 = (hh == 8'h12);

// Increment hours if minutes rollover
// Implement increment for hours 01..12 in BCD
// hour_rollover indicates hour increment wraps from 12 to 1
wire [3:0] hh_tens = hh[7:4];
wire [3:0] hh_ones = hh[3:0];
wire [3:0] hh_ones_inc = (hh_ones == 4'd9) ? 4'd0 : hh_ones + 4'd1;
wire [3:0] hh_tens_inc = (hh_ones == 4'd9) ? (hh_tens + 4'd1) : hh_tens;

// Temporary incremented hour before wrap check
wire [7:0] hh_inc_temp = {hh_tens_inc, hh_ones_inc};
// Check if next hour exceeds 12
wire hh_exceeds_12 = (hh_inc_temp > 8'h12);

// Calculate next hour, with wraparound to 01
assign hour_rollover = mm_rollover && ss_rollover && (hh == 8'h12);

assign hh_next = (mm_rollover && ss_rollover) ? 
                 ((hh_exceeds_12) ? 8'h01 : hh_inc_temp)
                 : hh;

// pm toggles only when incrementing from 11 to 12
assign pm_toggle = mm_rollover && ss_rollover && is_11;

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        ss <= ss_next;
        mm <= mm_next;
        hh <= hh_next;
        pm <= pm_toggle ? ~pm : pm;
    end
end

endmodule