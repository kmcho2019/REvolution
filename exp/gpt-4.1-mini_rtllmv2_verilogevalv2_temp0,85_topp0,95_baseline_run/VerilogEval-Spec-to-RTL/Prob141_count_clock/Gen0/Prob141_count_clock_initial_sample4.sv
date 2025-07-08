module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment BCD digit with max limit; returns incremented digit and carry
function automatic [1:0] bcd_inc;
    input [3:0] digit;
    input [3:0] max;
    begin
        if(digit == max) begin
            bcd_inc = {1'b1, 4'd0}; // carry 1 and digit reset to 0
        end else begin
            bcd_inc = {1'b0, digit + 1'b1}; // carry 0 and digit incremented
        end
    end
endfunction

// Increment BCD pair representing two digits (tens and units) with max value
// Returns incremented 8-bit BCD and carry flag
function automatic [9:0] bcd_pair_inc;
    input [7:0] bcd;
    input [7:0] max_bcd;
    reg carry_units, carry_tens;
    reg [3:0] units, tens;
    reg [3:0] max_units, max_tens;
    reg [3:0] new_units, new_tens;
    begin
        units = bcd[3:0];
        tens = bcd[7:4];
        max_units = max_bcd[3:0];
        max_tens = max_bcd[7:4];

        {carry_units,new_units} = bcd_inc(units, max_units);
        if(carry_units) begin
            {carry_tens,new_tens} = bcd_inc(tens, max_tens);
        end else begin
            carry_tens = 0;
            new_tens = tens;
        end

        bcd_pair_inc = {carry_tens, new_tens, new_units};
    end
endfunction

// 12-hour clock limits in BCD:
// Hours: 01 to 12 (BCD 0x01 to 0x12)
// Minutes/Seconds: 00 to 59 (BCD 0x00 to 0x59)

wire [9:0] ss_inc; // {carry, bcd}
wire [9:0] mm_inc;
wire [9:0] hh_inc;

assign ss_inc = bcd_pair_inc(ss, 8'h59);
assign mm_inc = bcd_pair_inc(mm, 8'h59);

// For hours we need special logic because it goes 01-12 (0x01-0x12 BCD), not 00-11
// Manual increment function for hours BCD with wrap from 12 to 1 and carry out
function automatic [9:0] hour_inc;
    input [7:0] hour_bcd;
    reg [3:0] h_tens, h_units;
    reg [3:0] next_tens, next_units;
    reg carry_out;
    reg [7:0] next_hour;
    begin
        h_tens = hour_bcd[7:4];
        h_units = hour_bcd[3:0];
        // Convert to integer hour for easier logic: hour = tens*10 + units
        integer h_val;
        h_val = h_tens*10 + h_units;

        if(h_val == 12) begin
            // wrap to 1, carry out
            next_hour = 8'h01;
            carry_out = 1'b1;
        end else begin
            // increment hour by 1
            h_val = h_val + 1;
            // convert back to BCD
            next_tens = h_val / 10;
            next_units = h_val % 10;
            next_hour = {next_tens, next_units};
            carry_out = 1'b0;
        end

        hour_inc = {carry_out, next_hour};
    end
endfunction

always @(posedge clk) begin
    if(reset) begin
        // synchronous reset: 12:00 AM
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if(ena) begin
        // increment seconds
        if(ss_inc[9]) begin
            // seconds wrapped, increment minutes
            ss <= ss_inc[7:0];
            if(mm_inc[9]) begin
                // minutes wrapped, increment hours
                mm <= mm_inc[7:0];
                // increment hours with wrap and possible carry
                // hour_inc returns carry if hour wrapped from 12 to 1
                reg [9:0] hh_next;
                hh_next = hour_inc(hh);
                hh <= hh_next[7:0];
                // toggle pm if hour wrapped from 12 to 1 (carry out)
                if(hh_next[9]) pm <= ~pm;
            end else begin
                // no minute wrap
                mm <= mm_inc[7:0];
            end
        end else begin
            // no second wrap
            ss <= ss_inc[7:0];
        end
    end
end

endmodule