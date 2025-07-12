module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds, minutes, and hours
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens; // Hours in BCD (01-12)

// Helper function: increment BCD digit (0-9) with carry out
function automatic [4:0] bcd_increment(input [3:0] digit);
    begin
        if (digit == 4'd9)
            bcd_increment = {1'b1, 4'd0}; // carry=1, digit=0
        else
            bcd_increment = {1'b0, digit + 4'd1};
    end
endfunction

// Synchronous process to update time counters and pm
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2; // '2' units digit of 12
        hh_tens  <= 4'd1; // '1' tens digit of 12
        pm       <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        reg carry_sec_tens, carry_min_units, carry_min_tens, carry_hour_units, carry_hour_tens;
        reg [4:0] res;

        // Increment seconds units
        res = bcd_increment(ss_units);
        ss_units <= res[3:0];
        carry_sec_tens = res[4];

        // Increment seconds tens if units rolled over
        if (carry_sec_tens) begin
            res = bcd_increment(ss_tens);
            // Seconds tens max is 5, reset to 0 on carry out
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // seconds rollover, increment minutes
                // Increment minutes units
                res = bcd_increment(mm_units);
                mm_units <= res[3:0];
                carry_min_tens = res[4];

                // Increment minutes tens if units rolled over
                if (carry_min_tens) begin
                    res = bcd_increment(mm_tens);
                    // Minutes tens max is 5, reset to 0 on carry out
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // minutes rollover, increment hours
                        // Increment hours units and tens accordingly

                        // Increment hours units
                        res = bcd_increment(hh_units);

                        if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
                            // Special case: hour == 12, rollover to 1
                            hh_tens <= 4'd0;
                            hh_units <= 4'd1;
                            pm <= ~pm; // toggle pm on 12->1 rollover
                        end else begin
                            if (res[4]) begin
                                // units digit rolled over, increment tens digit
                                hh_units <= 4'd0;
                                res = bcd_increment(hh_tens);
                                hh_tens <= res[3:0];
                            end else begin
                                hh_units <= res[3:0];
                            end
                            // Handle 12-hour max wrap-around (12)
                            if ((hh_tens == 4'd1) && (hh_units == 4'd3)) begin
                                // hour 13 is invalid, wrap to 1
                                hh_tens <= 4'd0;
                                hh_units <= 4'd1;
                                pm <= ~pm; // toggle pm on 12->1 rollover
                            end
                        end
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end
            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
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