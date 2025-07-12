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
// Returns next hour BCD
function [7:0] bcd_increment_12(input [7:0] bcd);
    reg [3:0] ones, tens;
    reg [7:0] next;
    begin
        ones = bcd[3:0];
        tens = bcd[7:4];

        // Increment hour by one
        if (ones == 4'd9) begin
            ones = 4'd0;
            tens = tens + 4'd1;
        end else begin
            ones = ones + 4'd1;
        end
        next = {tens, ones};

        // If hour exceeds 12, wrap to 01
        if ((tens > 4'd1) || (tens == 4'd1 && ones > 4'd2)) begin
            next = 8'h01; // BCD 01
        end else if (next == 8'h00) begin
            // Avoid hour zero, wrap to 01
            next = 8'h01;
        end
        bcd_increment_12 = next;
    end
endfunction

// Function to compare BCD hours equality
function is_11(input [7:0] bcd);
    begin
        // 11 in BCD is 0x11
        is_11 = (bcd == 8'h11);
    end
endfunction

// Function to compare BCD hours equality
function is_12(input [7:0] bcd);
    begin
        // 12 in BCD is 0x12
        is_12 = (bcd == 8'h12);
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 12:00:00 AM
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Declare local variables for next states
        reg [7:0] next_ss;
        reg [7:0] next_mm;
        reg [7:0] next_hh;
        reg next_pm;
        reg seconds_rollover;
        reg minutes_rollover;
        reg toggle_pm;

        // Increment seconds
        next_ss = bcd_increment_59(ss);
        seconds_rollover = (ss == 8'h59);

        // Increment minutes if seconds rollover
        if (seconds_rollover) begin
            next_mm = bcd_increment_59(mm);
            minutes_rollover = (mm == 8'h59);
        end else begin
            next_mm = mm;
            minutes_rollover = 1'b0;
        end

        // Increment hours if minutes rollover
        if (minutes_rollover) begin
            // Detect if hour is 11 before increment
            // We'll toggle pm when incrementing from 11 to 12
            toggle_pm = is_11(hh);

            // Increment hour
            next_hh = bcd_increment_12(hh);
        end else begin
            next_hh = hh;
            toggle_pm = 1'b0;
        end

        // Determine next pm value
        if (toggle_pm)
            next_pm = ~pm;
        else
            next_pm = pm;

        // Update all outputs synchronously
        ss <= next_ss;
        mm <= next_mm;
        hh <= next_hh;
        pm <= next_pm;
    end
end

endmodule