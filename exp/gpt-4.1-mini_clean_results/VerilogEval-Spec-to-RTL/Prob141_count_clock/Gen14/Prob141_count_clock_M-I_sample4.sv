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
    // Hour in binary (1..12)
    reg [3:0] hour_bin;

    // Flags to cascade increments
    reg sec_rollover;
    reg min_rollover;
    reg hour_rollover;

    // Seconds counter block
    always @(posedge clk) begin
        if (reset) begin
            ss_units   <= 4'd0;
            ss_tens    <= 4'd0;
            sec_rollover <= 1'b0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    sec_rollover <= 1'b1;  // second rolls over
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                    sec_rollover <= 1'b0;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
                sec_rollover <= 1'b0;
            end
        end else begin
            sec_rollover <= 1'b0;
        end
    end

    // Minutes counter block
    always @(posedge clk) begin
        if (reset) begin
            mm_units   <= 4'd0;
            mm_tens    <= 4'd0;
            min_rollover <= 1'b0;
        end else if (ena && sec_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                    min_rollover <= 1'b1;  // minute rolls over
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                    min_rollover <= 1'b0;
                end
            end else begin
                mm_units <= mm_units + 4'd1;
                min_rollover <= 1'b0;
            end
        end else begin
            min_rollover <= 1'b0;
        end
    end

    // Hours counter block with PM toggle
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm <= 1'b0;
            hour_rollover <= 1'b0;
        end else if (ena && min_rollover) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
                hour_rollover <= 1'b1;  // hour rolls over 12->1
            end else begin
                hour_bin <= hour_bin + 4'd1;
                hour_rollover <= 1'b0;
            end

            // Toggle PM at hour transition 11->12 (detected previous hour was 11)
            if (hour_bin == 4'd11) begin
                pm <= ~pm;
            end
        end else begin
            hour_rollover <= 1'b0;
        end
    end

    // Output BCD conversion for hour
    always @(*) begin
        if (hour_bin <= 4'd9) begin
            hh = {4'd0, hour_bin};
        end else begin
            hh = {4'd1, hour_bin - 4'd10};
        end
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule