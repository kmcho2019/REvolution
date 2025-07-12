module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hh_hi, hh_lo;  // hours tens and ones
    reg [3:0] mm_hi, mm_lo;  // minutes tens and ones
    reg [3:0] ss_hi, ss_lo;  // seconds tens and ones
    
    // Rollover conditions
    wire ss_max = (ss_hi == 5) && (ss_lo == 9);
    wire mm_max = (mm_hi == 5) && (mm_lo == 9);
    wire hh_max = (hh_hi == 1) && (hh_lo == 2);
    
    // PM indicator (1 for PM, 0 for AM)
    assign pm = (hh_hi == 1 && hh_lo != 2) || (hh_hi == 0 && hh_lo == 0);
    
    // Output assignments
    assign hh = {hh_hi, hh_lo};
    assign mm = {mm_hi, mm_lo};
    assign ss = {ss_hi, ss_lo};
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_hi <= 1;
            hh_lo <= 2;
            mm_hi <= 0;
            mm_lo <= 0;
            ss_hi <= 0;
            ss_lo <= 0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
            
            // Minutes counter (on second rollover)
            if (ss_max) begin
                if (mm_lo == 9) begin
                    mm_lo <= 0;
                    mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
                end else begin
                    mm_lo <= mm_lo + 1;
                end
            end
            
            // Hours counter (on minute and second rollover)
            if (ss_max && mm_max) begin
                if (hh_max) begin
                    // 12 -> 1 transition
                    hh_hi <= 0;
                    hh_lo <= 1;
                end else if (hh_lo == 9) begin
                    hh_lo <= 0;
                    hh_hi <= hh_hi + 1;
                end else begin
                    hh_lo <= hh_lo + 1;
                end
            end
        end
    end

endmodule