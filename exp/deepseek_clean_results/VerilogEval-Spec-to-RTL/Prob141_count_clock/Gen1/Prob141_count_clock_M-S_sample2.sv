module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] ss_units;
    reg [3:0] ss_tens;
    reg [3:0] mm_units;
    reg [3:0] mm_tens;
    reg [3:0] hh_units;
    reg [3:0] hh_tens;

    // Assign outputs
    assign pm = pm_reg;
    assign ss = {ss_tens, ss_units};
    assign mm = {mm_tens, mm_units};
    assign hh = {hh_tens, hh_units};

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens <= 4'd0;
            mm_units <= 4'd0;
            mm_tens <= 4'd0;
            hh_units <= 4'd2;
            hh_tens <= 4'd1;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Seconds counter
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Minutes counter
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Hours counter
                            if (hh_units == 4'd1 && hh_tens == 4'd1) begin
                                // 11 -> 12, toggle PM
                                hh_units <= 4'd2;
                                hh_tens <= 4'd1;
                                pm_reg <= ~pm_reg;
                            end
                            else if (hh_units == 4'd2 && hh_tens == 4'd1) begin
                                // 12 -> 1
                                hh_units <= 4'd1;
                                hh_tens <= 4'd0;
                            end
                            else if (hh_units == 4'd9) begin
                                // 9 -> 10
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1;
                            end
                            else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end
                        else begin
                            mm_tens <= mm_tens + 4'd1;
                        end
                    end
                    else begin
                        mm_units <= mm_units + 4'd1;
                    end
                end
                else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end
            else begin
                ss_units <= ss_units + 4'd1;
            end
        end
    end

endmodule