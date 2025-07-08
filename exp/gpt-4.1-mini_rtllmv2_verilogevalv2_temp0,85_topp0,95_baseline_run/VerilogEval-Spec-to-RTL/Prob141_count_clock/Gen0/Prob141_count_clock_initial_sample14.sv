module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Helper function to increment BCD digit (4 bits), return carry
function automatic [4:0] bcd_inc(input [3:0] digit);
    begin
        if (digit == 4'd9)
            bcd_inc = {1'b1, 4'd0};
        else
            bcd_inc = {1'b0, digit + 4'd1};
    end
endfunction

// Increment BCD two-digit counter (8 bits) from 00 to max_val inclusive, outputs new value and carry
function automatic [9:0] bcd2_inc(input [7:0] val, input [7:0] max_val);
    reg [4:0] lsd_inc;
    reg [4:0] msd_inc;
    reg [3:0] lsd;
    reg [3:0] msd;
    reg [7:0] new_val;
    reg carry_out;
    begin
        lsd = val[3:0];
        msd = val[7:4];

        // Increment least significant digit
        lsd_inc = bcd_inc(lsd);
        if (lsd_inc[4] == 0) begin
            // no carry
            new_val = {msd, lsd_inc[3:0]};
            carry_out = 1'b0;
        end else begin
            // carry from LSB, increment MSB digit
            msd_inc = bcd_inc(msd);
            if (msd_inc[4] == 0) begin
                new_val = {msd_inc[3:0], 4'd0};
                carry_out = 1'b0;
            end else begin
                // carry out of both digits means number rolled over max_val+1
                // But we handle that after comparing to max_val
                new_val = {4'd0,4'd0};
                carry_out = 1'b1;
            end
        end

        // If new_val > max_val, roll over to 0 and carry out
        if (new_val > max_val) begin
            new_val = 8'd0;
            carry_out = 1'b1;
        end

        bcd2_inc = {carry_out, new_val};
    end
endfunction


// Increment hours BCD from 01 to 12 with special logic for 12-hour clock
// Returns new hours and carry_out when hour rolls over from 12 to 1
function automatic [9:0] hour_inc(input [7:0] hour_val);
    reg [3:0] msd, lsd;
    reg [7:0] new_hour;
    reg carry_out;
    begin
        msd = hour_val[7:4];
        lsd = hour_val[3:0];
        // Convert BCD to integer hour_val_int (1-12)
        integer hour_val_int;
        hour_val_int = msd*10 + lsd;
        // increment hour integer with rollover 1->12
        hour_val_int = hour_val_int + 1;
        carry_out = 1'b0;
        if (hour_val_int > 12)
            hour_val_int = 1;

        // Convert back to BCD
        new_hour = { (hour_val_int/10), (hour_val_int%10) };
        if (hour_val_int == 12) carry_out = 1'b1; else carry_out = 1'b0;

        hour_inc = {carry_out, new_hour};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00:00 AM
        hh <= 8'h12;  // 0x12 BCD for 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;   // AM
    end else if (ena) begin
        // Increment seconds, max 59
        reg sec_carry;
        reg [7:0] new_ss;
        {sec_carry,new_ss} = bcd2_inc(ss,8'h59);
        ss <= new_ss;

        if (sec_carry) begin
            // increment minutes max 59
            reg min_carry;
            reg [7:0] new_mm;
            {min_carry,new_mm} = bcd2_inc(mm,8'h59);
            mm <= new_mm;

            if (min_carry) begin
                // increment hours 1-12 BCD
                reg hr_carry;
                reg [7:0] new_hh;
                {hr_carry,new_hh} = hour_inc(hh);
                hh <= new_hh;
                if (hr_carry) begin
                    // toggle pm on rollover from 11 to 12
                    pm <= ~pm;
                end
            end
        end
    end
end

endmodule