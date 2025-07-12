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
    reg [7:0] hour_bcd_reg;

    // Increment seconds BCD digits on ena
    // Using separate always block for seconds increment
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

    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);

    // Increment minutes BCD digits on seconds rollover
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (ena && sec_rollover) begin
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

    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Increment hour and toggle pm on minutes rollover
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm       <= 1'b0;
        end else if (ena && sec_rollover && min_rollover) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end
            if (hour_bin == 4'd11) begin
                pm <= ~pm;
            end
        end
    end

    // Convert hour_bin to BCD and register only on hour change to reduce output glitches
    reg [3:0] prev_hour_bin;
    always @(posedge clk) begin
        if (reset) begin
            hour_bcd_reg <= 8'h12; // "12"
            prev_hour_bin <= 4'd12;
        end else if (hour_bin != prev_hour_bin) begin
            prev_hour_bin <= hour_bin;
            if (hour_bin <= 4'd9)
                hour_bcd_reg <= {4'd0, hour_bin};
            else
                hour_bcd_reg <= {4'd1, hour_bin - 4'd10};
        end
    end

    // Register minute and second outputs to reduce glitching and improve timing
    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'd0;
            ss <= 8'd0;
            hh <= 8'h12;
            pm <= 1'b0;
        end else begin
            mm <= {mm_tens, mm_units};
            ss <= {ss_tens, ss_units};
            hh <= hour_bcd_reg;
            // pm already updated in hour always block
        end
    end

endmodule