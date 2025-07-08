module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Function to add 1 to a BCD digit (4 bits)
    // Returns new digit and carry (1 if overflow from 9 to 0)
    function automatic [5:0] bcd_inc4;
        input [3:0] digit;
        reg [4:0] sum;
        begin
            sum = digit + 1;
            if (sum == 10)
                bcd_inc4 = {1'b1, 4'd0}; // carry=1, digit=0
            else
                bcd_inc4 = {1'b0, sum[3:0]};
        end
    endfunction

    // Increment a two-digit BCD number (8 bits) from 00 to 59
    // Returns new BCD and carry (1 if overflow from 59 to 00)
    function automatic [12:0] bcd_inc60;
        input [7:0] bcd;
        reg [3:0] low, high;
        reg carry_low, carry_high;
        begin
            low = bcd[3:0];
            high = bcd[7:4];
            {carry_low, low} = bcd_inc4(low);
            if (carry_low) begin
                {carry_high, high} = bcd_inc4(high);
                // if high > 5, reset to 0 and carry out = 1
                if (high > 4'd5) begin
                    high = 4'd0;
                    carry_high = 1'b1;
                end
            end else begin
                carry_high = 1'b0;
            end
            bcd_inc60 = {carry_high, high, low};
        end
    endfunction

    // Increment hour in 12-hour BCD format (01 to 12)
    // Returns new hour and carry (1 if hour rolled over from 12 to 01)
    function automatic [12:0] inc_hour_12;
        input [7:0] hour_bcd;
        reg [3:0] h_low, h_high;
        reg carry_low;
        reg carry_high;
        reg [7:0] new_hour;
        begin
            h_high = hour_bcd[7:4];
            h_low  = hour_bcd[3:0];

            // Increment ones digit
            {carry_low, h_low} = bcd_inc4(h_low);

            if (carry_low) begin
                // Increment tens digit
                {carry_high, h_high} = bcd_inc4(h_high);
            end else begin
                carry_high = 1'b0;
            end

            new_hour = {h_high, h_low};

            // Handle hour rollovers:
            // Valid hour BCD: 01 to 12
            // If new_hour > 12, reset to 01 and signal carry (rollover)
            if ((new_hour[7:4] > 4'd1) || // tens digit > 1
                (new_hour > 8'd12) || // greater than 12 decimal
                (new_hour == 8'd00)) begin
                // rollover to 01
                new_hour = 8'h01;
                carry_high = 1'b1;
            end

            inc_hour_12 = {carry_high, new_hour};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset
            pm <= 1'b0;   // AM
            hh <= 8'h12;  // 12
            mm <= 8'h00;  // 00
            ss <= 8'h00;  // 00
        end else if (ena) begin
            // Increment seconds
            reg [12:0] sec_inc;
            reg [12:0] min_inc;
            reg [12:0] hr_inc;
            reg rollover_sec, rollover_min, rollover_hr;

            sec_inc = bcd_inc60(ss);
            rollover_sec = sec_inc[12];
            ss <= sec_inc[7:0];

            if (rollover_sec) begin
                min_inc = bcd_inc60(mm);
                rollover_min = min_inc[12];
                mm <= min_inc[7:0];
                if (rollover_min) begin
                    hr_inc = inc_hour_12(hh);
                    rollover_hr = hr_inc[12];
                    hh <= hr_inc[7:0];
                    if (rollover_hr)
                        pm <= ~pm; // toggle AM/PM on hour rollover
                end
            end
        end
    end

endmodule