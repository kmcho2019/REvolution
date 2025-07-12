module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Seconds BCD digits
    reg [3:0] ss_ones, ss_tens;
    wire      sec_rollover;

    // Minutes BCD digits
    reg [3:0] mm_ones, mm_tens;
    wire      min_rollover;

    // Hours BCD digits (range 01 to 12)
    reg [3:0] hh_ones, hh_tens;

    // -------- Seconds Counter --------
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5)
                    ss_tens <= 4'd0;
                else
                    ss_tens <= ss_tens + 4'd1;
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end
    end
    assign sec_rollover = (ss_tens == 4'd5) && (ss_ones == 4'd9) && ena;

    // -------- Minutes Counter --------
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (sec_rollover) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5)
                    mm_tens <= 4'd0;
                else
                    mm_tens <= mm_tens + 4'd1;
            end else begin
                mm_ones <= mm_ones + 4'd1;
            end
        end
    end
    assign min_rollover = (mm_tens == 4'd5) && (mm_ones == 4'd9) && sec_rollover;

    // -------- Hours Counter --------
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12
            hh_tens <= 4'd1;
            hh_ones <= 4'd2;
            pm <= 1'b0; // AM
        end else if (min_rollover) begin
            // Current hour as BCD combined
            // Increase hour by 1 in BCD from 01 to 12
            // If hour = 12, roll over to 1, toggle pm

            // Decode hour as integer for easy comparison
            // hour = hh_tens * 10 + hh_ones
            // We compare as BCD digits here
            if ((hh_tens == 4'd1) && (hh_ones == 4'd2)) begin
                // rollover from 12 to 1
                hh_tens <= 4'd0;
                hh_ones <= 4'd1;
                pm <= ~pm; // toggle PM on rollover from 12
            end else begin
                // increment hour by 1 in BCD
                if (hh_ones == 4'd9) begin
                    hh_ones <= 4'd0;
                    hh_tens <= hh_tens + 4'd1;
                end else begin
                    hh_ones <= hh_ones + 4'd1;
                end
            end
        end
    end

    // Outputs as concatenations of tens and ones
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

endmodule