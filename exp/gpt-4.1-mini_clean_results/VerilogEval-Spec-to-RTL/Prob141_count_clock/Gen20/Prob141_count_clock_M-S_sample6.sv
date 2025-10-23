module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal registers: each BCD digit separately
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;
    reg [3:0] hh_units, hh_tens;

    // Helper task to increment a BCD digit with carry
    function automatic [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0}; // carry out, digit reset to 0
            else
                bcd_inc = {1'b0, digit + 4'd1};
        end
    endfunction

    // Check if hours == 12
    function automatic is_12;
        input [3:0] tens, units;
        begin
            is_12 = (tens == 4'd1) && (units == 4'd2);
        end
    endfunction

    // Check if hours == 11
    function automatic is_11;
        input [3:0] tens, units;
        begin
            is_11 = (tens == 4'd1) && (units == 4'd1);
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            ss_units <= 4'd0; ss_tens <= 4'd0;
            mm_units <= 4'd0; mm_tens <= 4'd0;
            hh_units <= 4'd2; hh_tens <= 4'd1; // 12
            pm       <= 1'b0; // AM
        end else if (ena) begin
            // Increment seconds
            reg sec_carry;
            reg min_carry;
            reg hr_carry;
            reg [4:0] tmp;

            // Seconds units increment
            tmp = bcd_inc(ss_units);
            ss_units <= tmp[3:0];
            sec_carry = tmp[4];

            if (sec_carry) begin
                // Seconds tens increment
                tmp = bcd_inc(ss_tens);
                ss_tens <= tmp[3:0];
                sec_carry = tmp[4];

                if (sec_carry) begin
                    // Seconds rolled over to 00
                    ss_units <= 4'd0;
                    ss_tens  <= 4'd0;

                    // Increment minutes units
                    tmp = bcd_inc(mm_units);
                    mm_units <= tmp[3:0];
                    min_carry = tmp[4];

                    if (min_carry) begin
                        // Increment minutes tens
                        tmp = bcd_inc(mm_tens);
                        mm_tens <= tmp[3:0];
                        min_carry = tmp[4];

                        if (min_carry) begin
                            // Minutes rolled over to 00
                            mm_units <= 4'd0;
                            mm_tens  <= 4'd0;

                            // Increment hours (BCD 01-12)
                            // If hour == 12, roll to 1 and toggle pm
                            if (is_12(hh_tens, hh_units)) begin
                                hh_units <= 4'd1;
                                hh_tens  <= 4'd0;
                                pm <= ~pm;
                            end else begin
                                // Normal hour increment
                                tmp = bcd_inc(hh_units);
                                hr_carry = tmp[4];
                                hh_units <= tmp[3:0];
                                if (hr_carry) begin
                                    tmp = bcd_inc(hh_tens);
                                    hh_tens <= tmp[3:0];
                                end
                            end
                        end
                    end
                end
            end else begin
                // No rollover: just update seconds units and keep others same
                // (other digits unchanged)
            end
        end
    end

    // Combine digits for output
    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule