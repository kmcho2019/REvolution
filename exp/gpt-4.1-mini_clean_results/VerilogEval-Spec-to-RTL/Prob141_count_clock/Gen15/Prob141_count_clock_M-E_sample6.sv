module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds, minutes, hours
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens;

// Function: Increment BCD digit with max value limit
// Returns (next_digit, carry_out)
function [4:0] bcd_inc_limit(input [3:0] digit, input [3:0] max_digit);
    reg [3:0] next_d;
    reg carry;
begin
    if (digit == max_digit) begin
        next_d = 4'd0;
        carry = 1'b1;
    end else begin
        next_d = digit + 4'd1;
        carry = 1'b0;
    end
    bcd_inc_limit = {carry, next_d};
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;    // AM
        hh_tens  <= 4'd1;    // hour = 12 => tens=1
        hh_units <= 4'd2;    // hour = 12 => units=2
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds units
        {ss_units, } = bcd_inc_limit(ss_units, 4'd9);
        if (ss_units == 4'd0) begin
            // Seconds units rolled over, increment seconds tens
            {ss_tens, } = bcd_inc_limit(ss_tens, 4'd5);
            if (ss_tens == 4'd0) begin
                // Seconds tens rolled over, increment minutes units
                {mm_units, } = bcd_inc_limit(mm_units, 4'd9);
                if (mm_units == 4'd0) begin
                    // Minutes units rolled over, increment minutes tens
                    {mm_tens, } = bcd_inc_limit(mm_tens, 4'd5);
                    if (mm_tens == 4'd0) begin
                        // Minutes tens rolled over, increment hours
                        // Increment hours as BCD in 01-12 range
                        // Compute next hour increment with special 12->1 rollover
                        reg carry_hour;
                        reg [3:0] next_hh_units, next_hh_tens;
                        // First increment units digit, max 9 (tentative)
                        {carry_hour, next_hh_units} = bcd_inc_limit(hh_units, 4'd9);
                        if (carry_hour) begin
                            // units rolled over from 9->0, increment tens
                            {carry_hour, next_hh_tens} = bcd_inc_limit(hh_tens, 4'd1);
                            // Now handle specific 12->1 rollover
                            // If hour was 12 (tens=1, units=2), next should be 1 (0 tens, 1 units)
                            if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
                                next_hh_tens = 4'd0;
                                next_hh_units = 4'd1;
                                carry_hour = 1'b0; // handled rollover, no carry out needed
                                pm <= ~pm; // Toggle PM when rolling from 12 to 1
                            end else if (carry_hour) begin
                                // tens rolled over from 1->0, and hour is NOT 12,
                                // just assign next_hh_tens=0, next_hh_units=0 and handle pm toggling
                                // but this state shouldn't occur as hour max is 12.
                                // For safety, roll back to 1
                                next_hh_tens = 4'd0;
                                next_hh_units = 4'd1;
                                carry_hour = 1'b0;
                                pm <= ~pm; // Also toggle pm as hour rolls from 12->1
                            end
                        end else begin
                            next_hh_tens = hh_tens;
                        end
                        hh_units <= next_hh_units;
                        hh_tens  <= next_hh_tens;
                    end
                end
            end
        end
    end
end

// Combine digits into BCD outputs
always @* begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule