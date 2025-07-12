module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment a BCD counter from 00 to max (e.g., 59)
// Returns carry flag when wraparound happens
function automatic [8:0] bcd_increment_00_to_59;
    input [7:0] bcd_in;
    reg [3:0] ones;
    reg [3:0] tens;
    reg carry_out;
    begin
        ones = bcd_in[3:0];
        tens = bcd_in[7:4];
        carry_out = 0;
        if (ones < 9)
            ones = ones + 1;
        else begin
            ones = 0;
            if (tens < 5)
                tens = tens + 1;
            else begin
                tens = 0;
                carry_out = 1;
            end
        end
        bcd_increment_00_to_59 = {carry_out, tens, ones};
    end
endfunction

// Function to increment hours in BCD, from 01 to 12, then wrap to 01
// Returns carry_out flag when wrapping from 12 to 01 (to toggle PM)
function automatic [8:0] bcd_increment_hour_01_to_12;
    input [7:0] bcd_in;
    reg [3:0] ones;
    reg [3:0] tens;
    reg carry_out;
    reg [7:0] next_hour;
    begin
        ones = bcd_in[3:0];
        tens = bcd_in[7:4];
        carry_out = 0;

        // Convert current hour to integer for logic
        // Hours are 1-12 only
        integer hour_int;
        hour_int = tens*10 + ones;

        if (hour_int == 12) begin
            next_hour = 8'h01;  // 01 in BCD
            carry_out = 1;
        end else begin
            // Increment hour by 1
            hour_int = hour_int + 1;
            // Convert back to BCD
            tens = hour_int / 10;
            ones = hour_int % 10;
            next_hour = {tens, ones};
        end

        bcd_increment_hour_01_to_12 = {carry_out, next_hour};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 12:00:00 AM
        hh <= 8'h12;  // 12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        // Use bcd_increment_00_to_59 for seconds
        reg [8:0] sec_inc;
        reg [8:0] min_inc;
        reg [8:0] hour_inc;
        sec_inc = bcd_increment_00_to_59(ss);
        ss <= sec_inc[7:0];
        if (sec_inc[8]) begin
            // Increment minutes
            min_inc = bcd_increment_00_to_59(mm);
            mm <= min_inc[7:0];
            if (min_inc[8]) begin
                // Increment hours
                hour_inc = bcd_increment_hour_01_to_12(hh);
                hh <= hour_inc[7:0];
                if (hour_inc[8]) begin
                    // Wrap from 12 to 1, toggle PM
                    pm <= ~pm;
                end
            end
        end
    end
end

endmodule