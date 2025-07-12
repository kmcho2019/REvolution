module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD counters for seconds
    reg [3:0] ss_ones, ss_tens;
    // BCD counters for minutes
    reg [3:0] mm_ones, mm_tens;
    // BCD counter for hours (01 to 12)
    reg [7:0] hour_bcd;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end
    end

    // Minutes counter increments when seconds roll over from 59 to 00
    wire sec_rollover = (ss_ones == 4'd9) && (ss_tens == 4'd5) && ena;

    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (sec_rollover) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                end
            end else begin
                mm_ones <= mm_ones + 4'd1;
            end
        end
    end

    // Hours counter increments when minutes roll over from 59 to 00
    wire min_rollover = (mm_ones == 4'd9) && (mm_tens == 4'd5) && sec_rollover;

    always @(posedge clk) begin
        if (reset) begin
            hour_bcd <= 8'h12; // 0x12 = BCD 12
            pm <= 1'b0;
        end else if (min_rollover) begin
            // Convert hour BCD to integer for comparisons and increment
            // Extract BCD digits
            reg [3:0] h_tens;
            reg [3:0] h_ones;
            h_tens = hour_bcd[7:4];
            h_ones = hour_bcd[3:0];
            if ((h_tens == 4'd1) && (h_ones == 4'd2)) begin
                // hour = 12, wrap to 1
                hour_bcd <= 8'h01;
            end else begin
                // Increment hour BCD
                if (h_ones == 4'd9) begin
                    hour_bcd <= {(h_tens + 4'd1), 4'd0};
                end else begin
                    hour_bcd <= {h_tens, (h_ones + 4'd1)};
                end
            end

            // Toggle pm when hour rolls from 11 to 12
            if ((h_tens == 4'd1) && (h_ones == 4'd1)) begin
                pm <= ~pm;
            end
        end
    end

    // Synchronous update of output ports
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            hh <= hour_bcd;
            mm <= {mm_tens, mm_ones};
            ss <= {ss_tens, ss_ones};
        end
    end

endmodule