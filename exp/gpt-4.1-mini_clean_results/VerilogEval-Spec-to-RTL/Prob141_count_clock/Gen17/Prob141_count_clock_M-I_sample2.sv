module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds, minutes, and hours
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;
    reg [3:0] hh_units, hh_tens; // hours 01 to 12 in BCD

    // Combinational signals for carries
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);
    wire hour_11_to_12 = (hh_tens == 4'd1) && (hh_units == 4'd1); // Detect 11

    // Next state signals
    reg [3:0] ss_units_nxt, ss_tens_nxt;
    reg [3:0] mm_units_nxt, mm_tens_nxt;
    reg [3:0] hh_units_nxt, hh_tens_nxt;
    reg        pm_nxt;

    always @(*) begin
        // Default next state is current state
        ss_units_nxt = ss_units;
        ss_tens_nxt  = ss_tens;
        mm_units_nxt = mm_units;
        mm_tens_nxt  = mm_tens;
        hh_units_nxt = hh_units;
        hh_tens_nxt  = hh_tens;
        pm_nxt       = pm;

        if (ena) begin
            // Increment seconds
            if (ss_units == 4'd9) begin
                ss_units_nxt = 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens_nxt = 4'd0;

                    // Seconds rollover - increment minutes
                    if (mm_units == 4'd9) begin
                        mm_units_nxt = 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens_nxt = 4'd0;

                            // Minutes rollover - increment hours
                            // Hours: 01..12 BCD increment
                            if ((hh_tens == 4'd1 && hh_units == 4'd2)) begin
                                // 12 -> 01
                                hh_tens_nxt = 4'd0;
                                hh_units_nxt = 4'd1;
                            end else if (hh_units == 4'd9) begin
                                // units 9->0, tens++
                                hh_units_nxt = 4'd0;
                                hh_tens_nxt = hh_tens + 4'd1;
                            end else begin
                                hh_units_nxt = hh_units + 4'd1;
                            end

                            // Toggle pm when hour rolls from 11 to 12
                            if (hour_11_to_12) begin
                                pm_nxt = ~pm;
                            end

                        end else begin
                            mm_tens_nxt = mm_tens + 4'd1;
                        end
                    end else begin
                        mm_units_nxt = mm_units + 4'd1;
                    end
                end else begin
                    ss_tens_nxt = ss_tens + 4'd1;
                end
            end else begin
                ss_units_nxt = ss_units + 4'd1;
            end
        end
    end

    // Sequential update block
    always @(posedge clk) begin
        if (reset) begin
            // Sync reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hh_units <= 4'd2; // '12' = tens=1 units=2, but to avoid confusion we assign tens=0, units=1 and units=2 here carefully:
            hh_tens  <= 4'd1; // 12
            pm       <= 1'b0;
            // Initialize outputs too
            ss       <= 8'h00;
            mm       <= 8'h00;
            hh       <= 8'h12;
        end else begin
            ss_units <= ss_units_nxt;
            ss_tens  <= ss_tens_nxt;
            mm_units <= mm_units_nxt;
            mm_tens  <= mm_tens_nxt;
            hh_units <= hh_units_nxt;
            hh_tens  <= hh_tens_nxt;
            pm       <= pm_nxt;

            // Update outputs only when changed to reduce toggling
            if ({ss_tens, ss_units} != ss)
                ss <= {ss_tens, ss_units};
            if ({mm_tens, mm_units} != mm)
                mm <= {mm_tens, mm_units};
            if ({hh_tens, hh_units} != hh)
                hh <= {hh_tens, hh_units};
        end
    end

endmodule