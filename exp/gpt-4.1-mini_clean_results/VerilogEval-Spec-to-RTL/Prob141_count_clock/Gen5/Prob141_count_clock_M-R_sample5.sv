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

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; // 4 bits enough to count 1 to 12

// Next-state signals
wire [3:0] next_ss_units, next_ss_tens;
wire [3:0] next_mm_units, next_mm_tens;
wire [3:0] next_hour_bin;
wire       hour_roll_11_to_12;

// Helper: Increment BCD digit with max value
function [3:0] inc_bcd_digit(input [3:0] digit, input [3:0] max_val);
    begin
        if (digit == max_val)
            inc_bcd_digit = 4'd0;
        else
            inc_bcd_digit = digit + 4'd1;
    end
endfunction

// Seconds units increment and rollover logic
assign next_ss_units = ena ? ((ss_units == 4'd9) ? 4'd0 : ss_units + 4'd1) : ss_units;
assign next_ss_tens  = ena ? ((ss_units == 4'd9) ? ((ss_tens == 4'd5) ? 4'd0 : ss_tens + 4'd1) : ss_tens) : ss_tens;

// Minutes units and tens increment logic
wire mm_inc = ena && (ss_units == 4'd9) && (ss_tens == 4'd5);

assign next_mm_units = mm_inc ? ((mm_units == 4'd9) ? 4'd0 : mm_units + 4'd1) : mm_units;
assign next_mm_tens  = mm_inc ? ((mm_units == 4'd9) ? ((mm_tens == 4'd5) ? 4'd0 : mm_tens + 4'd1) : mm_tens) : mm_tens;

// Hour increment logic
wire hour_inc = mm_inc && (mm_units == 4'd9) && (mm_tens == 4'd5);

// Detect hour roll from 11 to 12 for pm toggle
assign hour_roll_11_to_12 = (hour_bin == 4'd11) && hour_inc;

// Next hour binary count: 1..12 cycle
assign next_hour_bin = hour_inc ? ((hour_bin == 4'd12) ? 4'd1 : hour_bin + 4'd1) : hour_bin;

// Function to convert binary hour (1..12) to BCD
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    reg [7:0] val;
    begin
        // bin_hour ranges 1..12
        if (bin_hour <= 4'd9) begin
            val = {4'd0, bin_hour}; // tens=0, units=bin_hour
        end else begin
            // 10 to 12
            val = {4'd1, bin_hour - 4'd10};
        end
        bin_to_bcd_hour = val;
    end
endfunction

// Synchronous process updating all registers
always @(posedge clk) begin
    if (reset) begin
        pm        <= 1'b0;     // AM
        hour_bin  <= 4'd12;    // 12
        mm_tens   <= 4'd0;
        mm_units  <= 4'd0;
        ss_tens   <= 4'd0;
        ss_units  <= 4'd0;
    end else begin
        ss_units  <= next_ss_units;
        ss_tens   <= next_ss_tens;
        mm_units  <= next_mm_units;
        mm_tens   <= next_mm_tens;
        hour_bin  <= next_hour_bin;
        // Toggle pm when hour rolls from 11 to 12
        if (hour_roll_11_to_12)
            pm <= ~pm;
    end
end

// Outputs combinationally assigned from registers
always @* begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule