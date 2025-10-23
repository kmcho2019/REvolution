module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits for hours, minutes, seconds
reg [3:0] hh_tens, hh_units;
reg [3:0] mm_tens, mm_units;
reg [3:0] ss_tens, ss_units;

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        hh_tens  <= 4'd1;
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
        pm       <= 1'b0; // AM
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

                        // Hours increment (01 to 12)
                        if (hh_tens == 4'd0) begin
                            // 01-09 hours
                            if (hh_units == 4'd9) begin
                                hh_tens  <= 4'd1;
                                hh_units <= 4'd0;
                            end else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end else if (hh_tens == 4'd1) begin
                            // 10-12 hours
                            if (hh_units == 4'd2) begin
                                hh_tens  <= 4'd0;
                                hh_units <= 4'd1;
                                pm <= ~pm; // toggle pm on roll from 12 to 1
                            end else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end else begin
                            // Safety fallback (should not happen)
                            hh_tens  <= 4'd0;
                            hh_units <= 4'd1;
                        end

                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule