module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Internal binary hour (1 to 12)
    reg [3:0] hour_bin;

    // Registered BCD hour output, updated only on hour_bin change
    reg [7:0] hh_next;

    // Rollover detection wires
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Binary to BCD hour conversion function (1..12)
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    endfunction

    // Sequential logic block: counters, pm, and hh_next update
    always @(posedge clk) begin
        if (reset) begin
            // Reset clock to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            hh_next  <= bin_to_bcd_hour(4'd12);
        end else if (ena) begin
            // Increment seconds BCD
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5)
                    ss_tens <= 4'd0;
                else
                    ss_tens <= ss_tens + 4'd1;
            end else begin
                ss_units <= ss_units + 4'd1;
            end

            // Increment minutes BCD on seconds rollover
            if (sec_rollover) begin
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5)
                        mm_tens <= 4'd0;
                    else
                        mm_tens <= mm_tens + 4'd1;
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

                // Increment hour_bin on minute rollover
                if (min_rollover) begin
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end

                    // Toggle pm when hour rolls from 11 to 12
                    if (hour_bin == 4'd11)
                        pm <= ~pm;

                    // Update hh_next BCD on hour change
                    hh_next <= bin_to_bcd_hour(
                        (hour_bin == 4'd12) ? 4'd1 : (hour_bin + 4'd1)
                    );
                end
            end
        end
    end

    // Register BCD hour output synchronously to avoid combinational toggling
    always @(posedge clk) begin
        hh <= hh_next;
    end

    // Combinational output for minutes and seconds (fast changing)
    always @(*) begin
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule