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

    // Hour BCD registered output
    reg [7:0] hh_bcd_reg;

    // Helper signals for increment carries
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Convert binary hour to BCD (registered) inside always block to reduce combinational logic on outputs
    function [7:0] bin_to_bcd(input [3:0] bin_hour);
        begin
            case (bin_hour)
                4'd1:  bin_to_bcd = 8'h01;
                4'd2:  bin_to_bcd = 8'h02;
                4'd3:  bin_to_bcd = 8'h03;
                4'd4:  bin_to_bcd = 8'h04;
                4'd5:  bin_to_bcd = 8'h05;
                4'd6:  bin_to_bcd = 8'h06;
                4'd7:  bin_to_bcd = 8'h07;
                4'd8:  bin_to_bcd = 8'h08;
                4'd9:  bin_to_bcd = 8'h09;
                4'd10: bin_to_bcd = 8'h10;
                4'd11: bin_to_bcd = 8'h11;
                4'd12: bin_to_bcd = 8'h12;
                default: bin_to_bcd = 8'h12; // default to 12 if invalid
            endcase
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
            hh_bcd_reg <= 8'h12; // "12"
            mm       <= 8'd0;
            ss       <= 8'd0;
            hh       <= 8'h12;
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
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end

                    // Toggle pm when hour rolls from 11 to 12
                    if (hour_bin == 4'd11) begin
                        pm <= ~pm;
                    end
                end
            end
        end

        // Register outputs every clock for stable timing
        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};

        // Update hour BCD output only when hour_bin changes
        // We detect hour change by comparing new hour_bin with hh_bcd_reg; no extra storage needed since hour_bin changes only on minute rollover
        // To reduce toggling, update only if different
        // But for simplicity and synthesis friendliness, update every clock with current conversion:
        // This is low overhead and eliminates extra registers or flags.
        hh_bcd_reg <= bin_to_bcd(hour_bin);
        hh <= hh_bcd_reg;
    end

endmodule