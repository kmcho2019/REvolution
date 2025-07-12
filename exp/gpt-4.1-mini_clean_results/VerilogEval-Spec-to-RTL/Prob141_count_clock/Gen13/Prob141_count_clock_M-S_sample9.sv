module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds
    reg [3:0] ss_units, ss_tens;
    // BCD digits for minutes
    reg [3:0] mm_units, mm_tens;
    // BCD digits for hours
    reg [3:0] hh_units, hh_tens;

    wire sec_wrap = (ss_units == 4'd9) && (ss_tens == 4'd5);
    wire min_wrap = (mm_units == 4'd9) && (mm_tens == 4'd5);

    // Indicates hour is currently 11 in BCD (for pm toggle)
    wire hour_is_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);
    // Indicates hour is currently 12 in BCD
    wire hour_is_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm        <= 1'b0;
            hh_tens   <= 4'd1;
            hh_units  <= 4'd2;
            mm_tens   <= 4'd0;
            mm_units  <= 4'd0;
            ss_tens   <= 4'd0;
            ss_units  <= 4'd0;
        end else if (ena) begin
            // Seconds increment
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Minutes increment
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Hours increment in 12-hour BCD format
                            if (hour_is_12) begin
                                // Wrap hours to 01 and toggle pm
                                hh_tens <= 4'd0;
                                hh_units <= 4'd1;
                                pm <= ~pm;
                            end else if (hh_units == 4'd9) begin
                                // Units digit rolls from 9 to 0, tens digit increments
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1;
                            end else begin
                                // Increment units digit
                                hh_units <= hh_units + 4'd1;
                            end
                        end else begin
                            // Increment minute tens digit
                            mm_tens <= mm_tens + 4'd1;
                        end
                    end else begin
                        // Increment minute units digit
                        mm_units <= mm_units + 4'd1;
                    end
                end else begin
                    // Increment second tens digit
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                // Increment second units digit
                ss_units <= ss_units + 4'd1;
            end
        end
    end

    // Output concatenation
    always @* begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule