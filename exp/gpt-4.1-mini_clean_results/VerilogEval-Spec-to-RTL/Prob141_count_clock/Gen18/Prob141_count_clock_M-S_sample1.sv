module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD counters for seconds, minutes, hours
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;
    reg [3:0] hh_units, hh_tens;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0;        // AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hh_units <= 4'd2;  // 12 in BCD: tens=1, units=2; but using tens=1 to represent '12' better for clarity below, so tens=1, units=2
            hh_tens  <= 4'd1;
        end else if (ena) begin
            // Increment seconds BCD
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;

                    // Increment minutes BCD
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;

                            // Increment hours BCD (1 to 12)
                            if (hh_tens == 4'd1 && hh_units == 4'd2) begin
                                // Roll from 12 to 1, toggle pm
                                hh_tens <= 4'd0;
                                hh_units <= 4'd1;
                                pm <= ~pm;
                            end else if (hh_units == 4'd9) begin
                                // E.g. 09 -> 10
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 1;
                            end else begin
                                hh_units <= hh_units + 1;
                            end
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_units <= mm_units + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_units <= ss_units + 1;
            end
        end
    end

    // Output assignments
    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule