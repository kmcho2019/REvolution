module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh, // two BCD digits for hour (01-12)
    output reg [7:0]  mm, // two BCD digits for minute (00-59)
    output reg [7:0]  ss  // two BCD digits for second (00-59)
);

    // Seconds digits (BCD)
    reg [3:0] ss_units, ss_tens;
    // Minutes digits (BCD)
    reg [3:0] mm_units, mm_tens;
    // Hours digits (BCD)
    reg [3:0] hh_units, hh_tens;

    // Flags to indicate rollovers
    wire sec_rollover;
    wire min_rollover;
    wire hour_rollover;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5)
                    ss_tens <= 4'd0;
                else
                    ss_tens <= ss_tens + 4'd1;
            end else begin
                ss_units <= ss_units + 4'd1;
            end
        end
    end

    assign sec_rollover = (ss_units == 4'd9) && (ss_tens == 4'd5) && ena;

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (sec_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5)
                    mm_tens <= 4'd0;
                else
                    mm_tens <= mm_tens + 4'd1;
            end else begin
                mm_units <= mm_units + 4'd1;
            end
        end
    end

    assign min_rollover = sec_rollover && (mm_units == 4'd9) && (mm_tens == 4'd5);

    // Hours counter (1..12 in BCD)
    // Increment only on min_rollover
    always @(posedge clk) begin
        if (reset) begin
            hh_units <= 4'd2; // 12 -> units = 2
            hh_tens  <= 4'd1; // 12 -> tens = 1
            pm       <= 1'b0; // AM
        end else if (min_rollover) begin
            if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
                // Hour rollover from 12 -> 01, toggle pm
                hh_tens  <= 4'd0;
                hh_units <= 4'd1;
                pm       <= ~pm;
            end else if (hh_tens == 4'd0) begin
                if (hh_units == 4'd9) begin
                    // Increment from 9 to 10
                    hh_units <= 4'd0;
                    hh_tens  <= 4'd1;
                end else begin
                    hh_units <= hh_units + 4'd1;
                end
            end else if (hh_tens == 4'd1) begin
                // Tens digit is 1 -> only valid units: 0,1,2
                if (hh_units == 4'd2) begin
                    // This should not happen here since rollover handled above
                    hh_units <= 4'd1; // Defensive fallback
                end else begin
                    hh_units <= hh_units + 4'd1;
                end
            end else begin
                // Defensive default: set to 01
                hh_tens  <= 4'd0;
                hh_units <= 4'd1;
            end
        end
    end

    // Output assignments
    always @(posedge clk) begin
        hh <= {hh_tens, hh_units};
        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end

endmodule