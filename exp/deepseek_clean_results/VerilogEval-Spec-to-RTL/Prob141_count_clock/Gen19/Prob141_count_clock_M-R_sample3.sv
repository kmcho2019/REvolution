module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Seconds counters
    reg [3:0] ss_lo;  // 0-9
    reg [2:0] ss_hi;  // 0-5
    wire ss_lo_roll = (ss_lo == 9);
    wire ss_hi_roll = (ss_hi == 5) && ss_lo_roll;

    // Minutes counters
    reg [3:0] mm_lo;  // 0-9
    reg [2:0] mm_hi;  // 0-5
    wire mm_lo_roll = (mm_lo == 9);
    wire mm_hi_roll = (mm_hi == 5) && mm_lo_roll;
    wire min_roll = mm_hi_roll && ss_hi_roll;

    // Hours counters
    reg [3:0] hh_lo;  // 0-9 (units digit)
    reg [0:0] hh_hi;  // 0-1 (tens digit)
    wire hour_roll = (hh_lo == 2) && (hh_hi == 1) && min_roll; // 12->1

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_lo <= 0;
            ss_hi <= 0;
        end else if (ena) begin
            if (ss_lo_roll) begin
                ss_lo <= 0;
                if (ss_hi_roll)
                    ss_hi <= 0;
                else
                    ss_hi <= ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_lo <= 0;
            mm_hi <= 0;
        end else if (ena && ss_hi_roll) begin
            if (mm_lo_roll) begin
                mm_lo <= 0;
                if (mm_hi_roll)
                    mm_hi <= 0;
                else
                    mm_hi <= mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hh_lo <= 2;
            hh_hi <= 1;
            pm <= 0;
        end else if (ena && min_roll) begin
            if (hour_roll) begin
                hh_lo <= 1;
                hh_hi <= 0;
            end else if (hh_lo == 9) begin
                hh_lo <= 0;
                hh_hi <= hh_hi + 1;
            end else begin
                hh_lo <= hh_lo + 1;
            end
            
            // Toggle PM at 11->12 transition
            if (hh_lo == 1 && hh_hi == 1) // 11
                pm <= ~pm;
        end
    end

    // Output registers (BCD format)
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
        end else begin
            ss <= {1'b0, ss_hi, ss_lo};
            mm <= {1'b0, mm_hi, mm_lo};
            hh <= {4'b0, hh_hi, hh_lo};
        end
    end

endmodule