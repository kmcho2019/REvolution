module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Internal digit registers
reg [3:0] ss_ones, ss_tens;
reg [3:0] mm_ones, mm_tens;
reg [3:0] hh_ones, hh_tens;

wire [3:0] next_ss_ones, next_ss_tens;
wire [3:0] next_mm_ones, next_mm_tens;
wire [3:0] next_hh_ones, next_hh_tens;

wire seconds_rollover;
wire minutes_rollover;
wire hour_rollover;

// Seconds increment logic
assign {seconds_rollover, next_ss_ones} = (ss_ones == 4'd9) ? {1'b1, 4'd0} : {1'b0, ss_ones + 4'd1};
assign next_ss_tens = seconds_rollover ? ((ss_tens == 4'd5) ? 4'd0 : ss_tens + 4'd1) : ss_tens;
assign seconds_rollover = (ss_tens == 4'd5) && (ss_ones == 4'd9);

// Minutes increment logic (triggered by seconds rollover)
wire minutes_increment = seconds_rollover;
assign {minutes_rollover, next_mm_ones} = minutes_increment ? 
    ((mm_ones == 4'd9) ? { (mm_tens == 4'd5), 4'd0 } : {1'b0, mm_ones + 4'd1}) : {1'b0, mm_ones};
assign next_mm_tens = minutes_increment ? ((mm_ones == 4'd9) ? ((mm_tens == 4'd5) ? 4'd0 : mm_tens + 4'd1) : mm_tens) : mm_tens;
assign minutes_rollover = minutes_increment && (mm_tens == 4'd5) && (mm_ones == 4'd9);

// Hour increment logic (triggered by minutes rollover)
wire hours_increment = minutes_rollover;

// Current hour in binary for comparisons
wire [7:0] curr_hour_bcd = {hh_tens, hh_ones};

// Calculate next hour digits
reg [3:0] temp_hh_ones;
reg [3:0] temp_hh_tens;

always @(*) begin
    if (hours_increment) begin
        // Increment hour with 12-hour wrap: 01 to 12 cycling
        if (hh_tens == 4'd1 && hh_ones == 4'd2) begin
            // If 12, roll over to 01
            temp_hh_tens = 4'd0;
            temp_hh_ones = 4'd1;
        end else begin
            // Increment ones digit
            if (hh_ones == 4'd9) begin
                temp_hh_ones = 4'd0;
                temp_hh_tens = hh_tens + 4'd1;
            end else begin
                temp_hh_ones = hh_ones + 4'd1;
                temp_hh_tens = hh_tens;
            end
        end
    end else begin
        // Hold current hour if no increment
        temp_hh_ones = hh_ones;
        temp_hh_tens = hh_tens;
    end
end

assign next_hh_ones = temp_hh_ones;
assign next_hh_tens = temp_hh_tens;

// Detect hour toggle event: toggle pm on hour increment from 11 to 12
wire toggle_pm = hours_increment && (hh_tens == 4'd1) && (hh_ones == 4'd1) && (next_hh_tens == 4'd1) && (next_hh_ones == 4'd2);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 12:00:00 AM
        hh_tens <= 4'd1;
        hh_ones <= 4'd2;
        mm_tens <= 4'd0;
        mm_ones <= 4'd0;
        ss_tens <= 4'd0;
        ss_ones <= 4'd0;
        pm <= 1'b0;  // AM
    end else if (ena) begin
        // Update seconds
        ss_tens <= next_ss_tens;
        ss_ones <= next_ss_ones;

        // Update minutes
        mm_tens <= next_mm_tens;
        mm_ones <= next_mm_ones;

        // Update hours
        hh_tens <= next_hh_tens;
        hh_ones <= next_hh_ones;

        // Toggle pm if hour increment from 11 to 12
        if (toggle_pm)
            pm <= ~pm;
    end
end

// Combine BCD digits for outputs
always @(*) begin
    hh = {hh_tens, hh_ones};
    mm = {mm_tens, mm_ones};
    ss = {ss_tens, ss_ones};
end

endmodule