module TopModule(
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Seconds counter: 00 to 59 in BCD
    wire sec_rollover;
    reg [3:0] sec_l, sec_h;

    always @(posedge clk) begin
        if (reset) begin
            sec_l <= 4'd0;
            sec_h <= 4'd0;
        end else if (ena) begin
            if (sec_l == 4'd9) begin
                sec_l <= 4'd0;
                if (sec_h == 4'd5)
                    sec_h <= 4'd0;
                else
                    sec_h <= sec_h + 4'd1;
            end else begin
                sec_l <= sec_l + 4'd1;
            end
        end
    end
    assign sec_rollover = (sec_h == 4'd5) && (sec_l == 4'd9) && ena;

    // Minutes counter: 00 to 59 in BCD
    wire min_rollover;
    reg [3:0] min_l, min_h;

    always @(posedge clk) begin
        if (reset) begin
            min_l <= 4'd0;
            min_h <= 4'd0;
        end else if (sec_rollover) begin
            if (min_l == 4'd9) begin
                min_l <= 4'd0;
                if (min_h == 4'd5)
                    min_h <= 4'd0;
                else
                    min_h <= min_h + 4'd1;
            end else begin
                min_l <= min_l + 4'd1;
            end
        end
    end
    assign min_rollover = (min_h == 4'd5) && (min_l == 4'd9) && sec_rollover;

    // Hours counter: 01 to 12 in BCD (tens digit 0 or 1, units digit 1-9 or 0-2)
    reg [3:0] hour_l, hour_h;

    // Detect if hour is 11 (to toggle pm on next increment)
    wire hour_is_11 = (hour_h == 4'd1) && (hour_l == 4'd1);

    always @(posedge clk) begin
        if (reset) begin
            hour_h <= 4'd1; // tens digit = 1
            hour_l <= 4'd2; // units digit = 2 (=> 12)
            pm <= 1'b0;     // AM
        end else if (min_rollover) begin
            // increment hour from 01..12 BCD
            if (hour_h == 4'd1 && hour_l == 4'd2) begin
                // 12 -> 1
                hour_h <= 4'd0;
                hour_l <= 4'd1;
                pm <= ~pm;  // toggle pm
            end else if (hour_l == 4'd9) begin
                // units rollover, tens increment
                hour_l <= 4'd0;
                hour_h <= hour_h + 4'd1;
            end else begin
                hour_l <= hour_l + 4'd1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'h00;
            ss <= 8'h00;
            hh <= 8'h12; // 12
        end else begin
            // Pack BCD digits into output ports
            hh <= {hour_h, hour_l};
            mm <= {min_h, min_l};
            ss <= {sec_h, sec_l};
        end
    end

endmodule