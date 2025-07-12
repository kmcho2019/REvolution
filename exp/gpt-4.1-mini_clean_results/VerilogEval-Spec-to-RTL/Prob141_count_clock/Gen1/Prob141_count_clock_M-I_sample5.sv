module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment BCD counter for seconds and minutes (00 to 59)
function [7:0] bcd_increment_59(input [7:0] bcd);
    reg [3:0] ones, tens;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        bcd_increment_59 = {tens, ones};
    end
endfunction

// Function to increment hour BCD from 01 to 12, returns {overflow, new hour}
// overflow is set when hour rolls over from 12 to 01
function [8:0] bcd_increment_12(input [7:0] bcd);
    reg [3:0] ones, tens;
    reg [7:0] next;
    reg overflow;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];

        // Increment by 1
        if (ones == 4'd9) begin
            ones = 4'd0;
            tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        next = {tens, ones};

        // Check for overflow: valid hours are 01 to 12
        // If next > 12 (BCD), roll over to 01 and set overflow
        if ((tens > 4'd1) || (tens == 4'd1 && ones > 4'd2) || next == 8'h00) begin
            next = 8'h01;  // BCD for 01
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end

        bcd_increment_12 = {overflow, next};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12;  // 12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;   // AM
    end else if (ena) begin
        // Compute next second
        reg [7:0] ss_next;
        reg sec_rollover;
        ss_next = bcd_increment_59(ss);
        sec_rollover = (ss == 8'h59);

        // Compute next minute if second rolled over
        reg [7:0] mm_next;
        reg min_rollover;
        if (sec_rollover)
            mm_next = bcd_increment_59(mm);
        else
            mm_next = mm;
        min_rollover = sec_rollover && (mm == 8'h59);

        // Compute next hour if minute rolled over
        reg [7:0] hh_next;
        reg hour_rollover;
        reg hour_ovf;
        if (min_rollover) begin
            {hour_ovf, hh_next} = bcd_increment_12(hh);
            hour_rollover = hour_ovf;
        end else begin
            hh_next = hh;
            hour_rollover = 1'b0;
        end

        // Update registers
        ss <= ss_next;
        mm <= mm_next;
        hh <= hh_next;

        // Toggle pm only on hour rollover (12 -> 1)
        if (hour_rollover)
            pm <= ~pm;
    end
end

endmodule