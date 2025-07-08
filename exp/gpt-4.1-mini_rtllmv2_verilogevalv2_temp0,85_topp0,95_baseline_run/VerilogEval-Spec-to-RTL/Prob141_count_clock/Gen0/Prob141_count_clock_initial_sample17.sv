module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Helper function to increment a BCD two-digit counter with max limit
// Returns 1 if overflow (i.e., counter reached max and rolled over), else 0
function increment_bcd_2digit;
    input [7:0] value;
    input [7:0] max;
    reg [3:0] ones, tens;
    begin
        ones = value[3:0];
        tens = value[7:4];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == max[7:4]) begin
                tens = 4'd0;
                increment_bcd_2digit = 1;
            end else begin
                tens = tens + 4'd1;
                increment_bcd_2digit = 0;
            end
        end else begin
            ones = ones + 4'd1;
            increment_bcd_2digit = 0;
        end
        increment_bcd_2digit = increment_bcd_2digit; // output
    end
endfunction

// Because function return is one value, better to implement increment logic inline

// To simplify, implement increment with outputs in always block

// We'll implement increment logic inline in always block

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        hh <= 8'h12;  // 0x12 BCD for 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // increment seconds
        // increment seconds BCD counter
        // logic for seconds increment and overflow detection
        // seconds max 59 = 0x59 in BCD
        reg [3:0] ss_ones, ss_tens;
        reg [3:0] mm_ones, mm_tens;
        reg [3:0] hh_ones, hh_tens;
        reg sec_overflow;
        reg min_overflow;
        reg hr_overflow;
        reg [7:0] new_ss, new_mm, new_hh;
        ss_ones = ss[3:0];
        ss_tens = ss[7:4];
        mm_ones = mm[3:0];
        mm_tens = mm[7:4];
        hh_ones = hh[3:0];
        hh_tens = hh[7:4];

        // Increment seconds
        if (ss_ones == 4'd9) begin
            ss_ones = 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens = 4'd0;
                sec_overflow = 1;
            end else begin
                ss_tens = ss_tens + 4'd1;
                sec_overflow = 0;
            end
        end else begin
            ss_ones = ss_ones + 4'd1;
            sec_overflow = 0;
        end
        new_ss = {ss_tens, ss_ones};

        if (sec_overflow) begin
            // increment minutes
            if (mm_ones == 4'd9) begin
                mm_ones = 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens = 4'd0;
                    min_overflow = 1;
                end else begin
                    mm_tens = mm_tens + 4'd1;
                    min_overflow = 0;
                end
            end else begin
                mm_ones = mm_ones + 4'd1;
                min_overflow = 0;
            end
            new_mm = {mm_tens, mm_ones};
        end else begin
            new_mm = mm;
            min_overflow = 0;
        end

        if (min_overflow) begin
            // increment hours
            // Hours are BCD 01 to 12
            // increment hours BCD counting 1-12
            // increment hour carefully
            integer hour_decimal;
            hour_decimal = (hh_tens * 10) + hh_ones;
            hour_decimal = hour_decimal + 1;
            if (hour_decimal == 13)
                hour_decimal = 1;
            // convert back to BCD
            hh_tens = hour_decimal / 10;
            hh_ones = hour_decimal % 10;
            new_hh = {hh_tens[3:0], hh_ones[3:0]};
            // toggle pm if hour rolled from 11 to 12
            // i.e. when incremented hour_decimal = 12
            if (hour_decimal == 12) begin
                pm <= ~pm;
            end
        end else begin
            new_hh = hh;
        end

        // Update outputs
        ss <= new_ss;
        mm <= new_mm;
        hh <= new_hh;
    end
end

endmodule