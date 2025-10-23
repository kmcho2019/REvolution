module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // BCD digits for hours (01 to 12)
    reg [3:0] hh_units, hh_tens;

    // Internal signals for carry
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);
    wire hr_11_to_12 = (hh_tens == 4'd1) && (hh_units == 4'd1); // hour == 11

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hh_units <= 4'd2;
            hh_tens  <= 4'd1; // 12 in BCD
            pm       <= 1'b0;
            // Initialize outputs as well
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
        end else if (ena) begin
            // Seconds increment
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end

            // Minutes increment on seconds rollover
            if (sec_rollover) begin
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

                // Hours increment on minutes rollover
                if (min_rollover) begin
                    // Check if hour is 12
                    if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
                        // Roll over from 12 to 1
                        hh_tens <= 4'd0;
                        hh_units <= 4'd1;
                    end else if ((hh_tens == 4'd0) && (hh_units == 4'd9)) begin
                        // From 9 to 10
                        hh_tens <= 4'd1;
                        hh_units <= 4'd0;
                    end else begin
                        // Normal BCD increment for units digit
                        if (hh_units == 4'd9) begin
                            hh_units <= 4'd0;
                            hh_tens <= hh_tens + 4'd1;
                        end else begin
                            hh_units <= hh_units + 4'd1;
                        end
                    end

                    // Toggle pm if hour rolls from 11 to 12
                    if (hr_11_to_12) begin
                        pm <= ~pm;
                    end
                end
            end

            // Update output registers synchronously only on increments to reduce toggling
            ss <= {ss_tens, ss_units};
            mm <= {mm_tens, mm_units};
            hh <= {hh_tens, hh_units};
        end
    end

endmodule