module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Second counter
    reg [3:0] ss_lo, ss_hi;
    wire ss_lo_roll = (ss_lo == 4'd9);
    wire ss_hi_roll = (ss_hi == 4'd5) && ss_lo_roll;
    
    always @(posedge clk) begin
        if (reset) {ss_hi, ss_lo} <= 8'h00;
        else if (ena) begin
            if (ss_lo_roll) begin
                ss_lo <= 0;
                ss_hi <= ss_hi_roll ? 0 : ss_hi + 1;
            end
            else ss_lo <= ss_lo + 1;
        end
    end

    // Minute counter
    reg [3:0] mm_lo, mm_hi;
    wire mm_lo_roll = (mm_lo == 4'd9);
    wire mm_hi_roll = (mm_hi == 4'd5) && mm_lo_roll;
    
    always @(posedge clk) begin
        if (reset) {mm_hi, mm_lo} <= 8'h00;
        else if (ena && ss_hi_roll && ss_lo_roll) begin
            if (mm_lo_roll) begin
                mm_lo <= 0;
                mm_hi <= mm_hi_roll ? 0 : mm_hi + 1;
            end
            else mm_lo <= mm_lo + 1;
        end
    end

    // Hour counter and PM indicator
    reg [7:0] hh_bcd;
    reg pm_reg;
    wire hour_roll = mm_hi_roll && mm_lo_roll && ss_hi_roll && ss_lo_roll;
    
    always @(posedge clk) begin
        if (reset) begin
            hh_bcd <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena && hour_roll) begin
            case (hh_bcd)
                8'h12: hh_bcd <= 8'h01;
                8'h09: hh_bcd <= 8'h10;
                8'h11: begin
                    hh_bcd <= 8'h12;
                    pm_reg <= ~pm_reg;
                end
                default: begin
                    if (hh_bcd[3:0] == 4'd9) begin
                        hh_bcd[7:4] <= hh_bcd[7:4] + 1;
                        hh_bcd[3:0] <= 0;
                    end
                    else hh_bcd[3:0] <= hh_bcd[3:0] + 1;
                end
            endcase
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = hh_bcd;

endmodule