module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Registered BCD hour output updated only on hour_bin change/reset
    reg [7:0] hh_reg;

    // Combinational rollover signals
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Convert binary hour (1..12) to BCD (two digits) - combinational function for internal use
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            hh_reg   <= bin_to_bcd_hour(4'd12);
            mm       <= 8'd0;
            ss       <= 8'd0;
        end else if (ena) begin
            // Increment seconds
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end

            // Increment minutes on seconds rollover
            if (sec_rollover) begin
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

                // Increment hours on minutes rollover
                if (min_rollover) begin
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                        pm <= ~pm; // Toggle pm when rolling from 12 to 1
                        hh_reg <= bin_to_bcd_hour(4'd1);
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                        // Toggle pm when hour_bin goes from 11 to 12
                        if (hour_bin == 4'd11) begin
                            pm <= ~pm;
                            hh_reg <= bin_to_bcd_hour(4'd12);
                        end else begin
                            hh_reg <= bin_to_bcd_hour(hour_bin + 4'd1);
                        end
                    end
                end
            end

            // Update output minute and second registers every ena pulse
            mm <= {mm_tens, mm_units};
            ss <= {ss_tens, ss_units};
        end else begin
            // When ena is low, outputs hold their value (no toggling)
            mm <= mm;
            ss <= ss;
            hh <= hh;
            pm <= pm;
        end
    end

    // Output hh is registered hour BCD updated on hour_bin changes
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd0;
        end else if (ena) begin
            hh <= hh_reg;
        end else begin
            hh <= hh;
        end
    end

endmodule