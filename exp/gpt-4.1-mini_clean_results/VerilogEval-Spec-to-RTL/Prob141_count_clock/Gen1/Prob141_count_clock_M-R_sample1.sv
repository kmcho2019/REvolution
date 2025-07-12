module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment BCD from 00 to 59
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
        end else
            ones = ones + 4'd1;
        bcd_increment_59 = {tens, ones};
    end
endfunction

// Function to increment hours BCD from 01 to 12
// Returns next hour and overflow flag indicating wrap from 12 to 1
function [8:0] bcd_increment_12(input [7:0] bcd);
    reg [3:0] ones, tens;
    reg [7:0] next;
    reg overflow;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];
        // Increment by one
        if (ones == 4'd9) begin
            ones = 4'd0;
            tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        next = {tens, ones};

        // Check if hour exceeds 12 BCD (0x12)
        if ((tens > 4'd1) || (tens == 4'd1 && ones > 4'd2)) begin
            next = 8'h01; // BCD 01
            overflow = 1'b1;
        end else if (next == 8'h00) begin
            // Prevent hour zero; wrap to 1 and overflow
            next = 8'h01;
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
        bcd_increment_12 = {overflow, next};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 12:00 AM
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Compute next seconds
        reg [7:0] next_ss;
        reg [7:0] next_mm;
        reg [7:0] next_hh;
        reg next_pm;
        reg hour_overflow;

        next_ss = bcd_increment_59(ss);

        if (ss == 8'h59) begin
            // Seconds roll over to 00, increment minutes
            next_mm = bcd_increment_59(mm);
            if (mm == 8'h59) begin
                // Minutes roll over, increment hours and potentially toggle pm
                {hour_overflow, next_hh} = bcd_increment_12(hh);
                next_pm = hour_overflow ? ~pm : pm;
            end else begin
                next_hh = hh;
                next_pm = pm;
            end
        end else begin
            next_mm = mm;
            next_hh = hh;
            next_pm = pm;
        end

        // Update all registers synchronously
        ss <= next_ss;
        mm <= next_mm;
        hh <= next_hh;
        pm <= next_pm;
    end
end

endmodule