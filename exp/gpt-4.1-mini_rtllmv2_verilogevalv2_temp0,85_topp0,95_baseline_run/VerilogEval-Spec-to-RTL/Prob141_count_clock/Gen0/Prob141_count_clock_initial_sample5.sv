module TopModule(
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// BCD digit increment helper function
// returns incremented value and carry
function automatic [1:0] bcd_increment;
    input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_increment = {1'b1, 4'd0}; // carry=1, digit=0
        else
            bcd_increment = {1'b0, digit + 4'd1};
    end
endfunction

// Helper: increment BCD seconds or minutes from 00 to 59
// Input: 8-bit BCD
// Output: new 8-bit BCD and carry out if roll over from 59 to 00
function automatic [8:0] bcd_inc_59;
    input [7:0] bcd_2d;
    reg [3:0] ones;
    reg [3:0] tens;
    reg carry_ones;
    reg carry_tens;
    reg [3:0] new_ones;
    reg [3:0] new_tens;
    begin
        ones = bcd_2d[3:0];
        tens = bcd_2d[7:4];

        {carry_ones, new_ones} = bcd_increment(ones);
        if (carry_ones) begin
            {carry_tens, new_tens} = bcd_increment(tens);
        end else begin
            carry_tens = 0;
            new_tens = tens;
        end

        // Check if new_tens > 5 (invalid for 0-59), if so rollover
        if (new_tens > 4'd5) begin
            new_tens = 4'd0;
            carry_tens = 1'b1;
        end

        bcd_inc_59 = {carry_tens, new_tens, new_ones};
    end
endfunction

// Helper: increment hour BCD for 12-hour format
// Hours go from 01 to 12 (BCD)
// On 12 -> 01 and toggle pm
// Input: hh[7:0] BCD hour
// Outputs: new hh[7:0], carry (unused), toggle_pm (1 if hour rolls from 12 to 1)
function automatic [9:0] hour_inc_12;
    input [7:0] curr_hh;
    reg [3:0] ones;
    reg [3:0] tens;
    reg [7:0] new_hh;
    reg toggle_pm;
    reg carry_dummy;
    begin
        ones = curr_hh[3:0];
        tens = curr_hh[7:4];

        // Cases:
        // If 12 -> 01 and toggle pm
        // If ones < 9, increment ones
        // If ones == 9, set ones=0 and increment tens
        if ((tens == 4'd1) && (ones == 4'd2)) begin
            // roll over from 12 to 01
            new_hh = 8'h01;
            toggle_pm = 1'b1;
        end else if (ones < 4'd9) begin
            new_hh = {tens, ones + 4'd1};
            toggle_pm = 1'b0;
        end else begin
            // ones == 9, increment tens
            {carry_dummy, tens} = bcd_increment(tens);
            ones = 4'd0;
            new_hh = {tens, ones};
            toggle_pm = 1'b0;
        end
        hour_inc_12 = {toggle_pm, 1'b0, new_hh};
    end
endfunction


always @(posedge clk) begin
    if (reset) begin
        // synchronous reset: 12:00:00 AM
        hh <= 8'h12;   // 12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // increment seconds
        // bcd_inc_59 returns {carry, tens, ones}
        reg [8:0] ss_next;
        reg [8:0] mm_next;
        reg [9:0] hh_next; // {toggle_pm, carry_dummy, hh}
        reg [7:0] new_hh;
        reg toggle_pm_bit;

        ss_next = bcd_inc_59(ss);
        ss <= ss_next[7:0];

        if (ss_next[8]) begin // seconds rolled over from 59 to 00
            // increment minutes
            mm_next = bcd_inc_59(mm);
            mm <= mm_next[7:0];

            if (mm_next[8]) begin
                // minutes rolled over 59->00, increment hours
                hh_next = hour_inc_12(hh);
                new_hh = hh_next[7:0];
                toggle_pm_bit = hh_next[9];
                hh <= new_hh;

                if (toggle_pm_bit)
                    pm <= ~pm;
            end
        end
    end
end

endmodule