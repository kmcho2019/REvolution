module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    // Current BCD digits for seconds, minutes, hours
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;
    reg [3:0] hh_units, hh_tens;

    // Next state signals
    reg [3:0] ss_units_next, ss_tens_next;
    reg [3:0] mm_units_next, mm_tens_next;
    reg [3:0] hh_units_next, hh_tens_next;
    reg       pm_next;

    // Combinational logic: generate next state and carry flags
    always @(*) begin
        // Default next values are current values
        ss_units_next = ss_units;
        ss_tens_next  = ss_tens;
        mm_units_next = mm_units;
        mm_tens_next  = mm_tens;
        hh_units_next = hh_units;
        hh_tens_next  = hh_tens;
        pm_next       = pm;

        if (ena) begin
            // Increment seconds units
            if (ss_units == 4'd9) begin
                ss_units_next = 4'd0;
                // Increment seconds tens
                if (ss_tens == 4'd5) begin
                    ss_tens_next = 4'd0;
                    // Seconds rolled over, increment minutes units
                    if (mm_units == 4'd9) begin
                        mm_units_next = 4'd0;
                        // Increment minutes tens
                        if (mm_tens == 4'd5) begin
                            mm_tens_next = 4'd0;
                            // Minutes rolled over, increment hours
                            // Hours count from 01 to 12 in BCD

                            // Check for hour = 11 (0x11)
                            if (hh_tens == 4'd1 && hh_units == 4'd1) begin
                                // Next hour = 12 (0x12)
                                hh_tens_next  = 4'd1;
                                hh_units_next = 4'd2;
                                // Toggle pm on hour from 11 to 12
                                pm_next = ~pm;
                            end
                            else if (hh_tens == 4'd1 && hh_units == 4'd2) begin
                                // If hour = 12, roll to 01
                                hh_tens_next  = 4'd0;
                                hh_units_next = 4'd1;
                            end
                            else begin
                                // Otherwise increment hour units digit
                                if (hh_units == 4'd9) begin
                                    hh_units_next = 4'd0;
                                    hh_tens_next = hh_tens + 4'd1;
                                end else begin
                                    hh_units_next = hh_units + 4'd1;
                                end
                            end
                        end else begin
                            mm_tens_next = mm_tens + 4'd1;
                        end
                    end else begin
                        mm_units_next = mm_units + 4'd1;
                    end
                end else begin
                    ss_tens_next = ss_tens + 4'd1;
                end
            end else begin
                ss_units_next = ss_units + 4'd1;
            end
        end
    end

    // Sequential logic: update registers on clock
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hh_units <= 4'd2;
            hh_tens  <= 4'd1;
            pm       <= 1'b0;
        end else begin
            ss_units <= ss_units_next;
            ss_tens  <= ss_tens_next;
            mm_units <= mm_units_next;
            mm_tens  <= mm_tens_next;
            hh_units <= hh_units_next;
            hh_tens  <= hh_tens_next;
            pm       <= pm_next;
        end
    end

    // Output assignments
    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule