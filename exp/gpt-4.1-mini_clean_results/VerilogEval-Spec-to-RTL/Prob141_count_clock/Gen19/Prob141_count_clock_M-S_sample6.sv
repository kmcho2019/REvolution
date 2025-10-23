module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Extract BCD digits from outputs for easier manipulation
    wire [3:0] ss_tens = ss[7:4];
    wire [3:0] ss_units = ss[3:0];
    wire [3:0] mm_tens = mm[7:4];
    wire [3:0] mm_units = mm[3:0];
    wire [3:0] hh_tens = hh[7:4];
    wire [3:0] hh_units = hh[3:0];

    // Helper tasks for incrementing BCD digits
    // Increment a BCD digit (0-9), returning carry (1 if overflow)
    function automatic [4:0] inc_bcd_digit;
        input [3:0] digit;
        reg [4:0] result;
    begin
        if(digit == 4'd9)
            result = 5'd0 + 5'd16; // 0 with carry set in bit 4
        else
            result = digit + 5'd1;
        inc_bcd_digit = result;
    end
    endfunction

    // Increment seconds BCD (00-59)
    function automatic [7:0] inc_seconds;
        input [7:0] sec;
        reg [4:0] unit_inc, ten_inc;
        reg [3:0] units, tens;
        reg carry;
    begin
        units = sec[3:0];
        tens = sec[7:4];
        unit_inc = inc_bcd_digit(units);
        carry = unit_inc[4];
        units = unit_inc[3:0];
        if (carry) begin
            ten_inc = inc_bcd_digit(tens);
            tens = ten_inc[3:0];
            carry = ten_inc[4];
            if (tens > 4'd5) begin
                tens = 4'd0;
                carry = 1'b1;
            end else begin
                carry = 1'b0;
            end
        end else begin
            carry = 1'b0;
        end
        inc_seconds = {tens, units};
    end
    endfunction

    // Check if seconds are at max (59)
    function automatic is_sec_rollover;
        input [7:0] sec;
    begin
        is_sec_rollover = (sec == 8'h59);
    end
    endfunction

    // Increment minutes BCD (00-59)
    function automatic [7:0] inc_minutes;
        input [7:0] minute;
        reg [4:0] unit_inc, ten_inc;
        reg carry;
        reg [3:0] units, tens;
    begin
        units = minute[3:0];
        tens = minute[7:4];
        unit_inc = inc_bcd_digit(units);
        carry = unit_inc[4];
        units = unit_inc[3:0];
        if (carry) begin
            ten_inc = inc_bcd_digit(tens);
            tens = ten_inc[3:0];
            carry = ten_inc[4];
            if (tens > 4'd5) begin
                tens = 4'd0;
                carry = 1'b1;
            end else begin
                carry = 1'b0;
            end
        end else begin
            carry = 1'b0;
        end
        inc_minutes = {tens, units};
    end
    endfunction

    // Check if minutes are at max (59)
    function automatic is_min_rollover;
        input [7:0] minute;
    begin
        is_min_rollover = (minute == 8'h59);
    end
    endfunction

    // Increment hours BCD (01-12)
    function automatic [7:0] inc_hours;
        input [7:0] hour;
        reg [3:0] units, tens;
    begin
        units = hour[3:0];
        tens = hour[7:4];
        if (hour == 8'h12) begin
            // rollover to 01
            inc_hours = 8'h01;
        end else if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd0) begin
                tens = 4'd1;
            end else begin
                // should only be 0 or 1, so else not needed logically
                tens = 4'd0;
            end
            inc_hours = {tens, units};
        end else begin
            units = units + 4'd1;
            inc_hours = {tens, units};
        end
    end
    endfunction

    reg [7:0] next_ss, next_mm, next_hh;
    reg next_pm;

    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;    // 12
            mm <= 8'h00;    // 00
            ss <= 8'h00;    // 00
            pm <= 1'b0;     // AM
        end else if (ena) begin
            if (is_sec_rollover(ss)) begin
                next_ss = 8'h00;
                if (is_min_rollover(mm)) begin
                    next_mm = 8'h00;
                    if (hh == 8'h11) begin
                        // hour rolls 11->12 pm toggle
                        next_hh = 8'h12;
                        next_pm = ~pm;
                    end else if (hh == 8'h12) begin
                        // hour rolls 12->1 am/pm unchanged except toggle done above
                        next_hh = 8'h01;
                        next_pm = pm;
                    end else begin
                        next_hh = inc_hours(hh);
                        next_pm = pm;
                    end
                    hh <= next_hh;
                    pm <= next_pm;
                end else begin
                    next_mm = inc_minutes(mm);
                end
                mm <= next_mm;
                ss <= next_ss;
            end else begin
                ss <= inc_seconds(ss);
            end
        end
    end

endmodule