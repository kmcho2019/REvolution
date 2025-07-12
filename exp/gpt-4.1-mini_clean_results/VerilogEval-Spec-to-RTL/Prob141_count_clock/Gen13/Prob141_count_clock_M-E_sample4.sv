module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD counters: tens and units for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // BCD counters for hours (1-12)
    reg [3:0] hh_units, hh_tens;

    // Synchronous counting logic with reset and enable
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm       <= 1'b0;    // AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hh_units <= 4'd2;    // 12 hours -> tens=1, units=2 but we set directly 2 here and tens below
            hh_tens  <= 4'd1;
        end else if (ena) begin
            // Increment seconds units
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                // Increment seconds tens
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Increment minutes units
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        // Increment minutes tens
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Increment hours (BCD, 1-12)
                            // Construct current hour as integer for easier comparison
                            // hour = tens*10 + units
                            // Implement hour increment and pm toggle logic
                            if ( (hh_tens == 4'd1 && hh_units == 4'd1) ) begin
                                // 11 -> increment to 12 and toggle pm
                                hh_tens <= 4'd1;
                                hh_units <= 4'd2;
                                pm <= ~pm;
                            end else if ( (hh_tens == 4'd1 && hh_units == 4'd2) ) begin
                                // 12 -> roll over to 01
                                hh_tens <= 4'd0;
                                hh_units <= 4'd1;
                            end else begin
                                // Normal increment (units)
                                if (hh_units == 4'd9) begin
                                    hh_units <= 4'd0;
                                    hh_tens <= hh_tens + 1'b1; // tens digit increment
                                end else begin
                                    hh_units <= hh_units + 1'b1;
                                end
                            end
                        end else begin
                            mm_tens <= mm_tens + 1'b1;
                        end
                    end else begin
                        mm_units <= mm_units + 1'b1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1'b1;
                end
            end else begin
                ss_units <= ss_units + 1'b1;
            end
        end
    end

    // Assign outputs directly from BCD counters
    always @(*) begin
        ss = {ss_tens, ss_units};
        mm = {mm_tens, mm_units};
        hh = {hh_tens, hh_units};
    end

endmodule