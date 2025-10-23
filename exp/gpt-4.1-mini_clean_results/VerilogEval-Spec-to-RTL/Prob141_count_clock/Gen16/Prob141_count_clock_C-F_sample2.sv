module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Seconds BCD digits
    reg [3:0] ss_units, ss_tens;
    wire      ss_rollover;

    // Minutes BCD digits
    reg [3:0] mm_units, mm_tens;
    wire      mm_rollover;

    // Hours binary counter (1..12)
    reg [3:0] hour_bin;
    reg       pm_next_toggle; // helper signal for pm toggle at hour rollover

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
        end else if (ena) begin
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
        end
    end

    assign ss_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (ss_rollover) begin
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
        end
    end

    assign mm_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9) && ss_rollover;

    // Hours counter and pm toggle
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            pm_next_toggle <= 1'b0;
        end else if (mm_rollover) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end

            // PM toggle when hour rolls from 11 to 12
            pm_next_toggle <= (hour_bin == 4'd11);
            if (pm_next_toggle)
                pm <= ~pm;
            else
                pm <= pm;
        end else begin
            pm_next_toggle <= 1'b0;
        end
    end

    // Output BCD conversion for hour_bin (1 to 12)
    // No subtraction, use simple conditional to select tens digit and units digit
    wire [3:0] hh_tens = (hour_bin > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hh_units = (hour_bin > 4'd9) ? (hour_bin - 4'd10) : hour_bin;

    assign hh = {hh_tens, hh_units};
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule