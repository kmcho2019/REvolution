module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    // Separate seconds digits
    reg [3:0] ss_units;
    reg [3:0] ss_tens;

    // Separate minutes digits
    reg [3:0] mm_units;
    reg [3:0] mm_tens;

    // Separate hours digits (BCD 01-12)
    reg [3:0] hh_units;
    reg [3:0] hh_tens;

    // Increment seconds
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
        end else if (ena) begin
            // Increment seconds units digit
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                // Increment seconds tens digit
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

    // Increment minutes on seconds rollover
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (ena && sec_rollover) begin
            // Increment minutes units digit
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                // Increment minutes tens digit
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

    // Increment hours on minutes rollover
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Detect if current hour is 11 (BCD)
    wire is_hour_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);
    // Detect if current hour is 12 (BCD)
    wire is_hour_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            hh_units <= 4'd2; // 12
            hh_tens  <= 4'd1;
            pm       <= 1'b0; // AM
        end else if (ena && sec_rollover && min_rollover) begin
            if (is_hour_12) begin
                // Roll hours back to 01 from 12
                hh_tens  <= 4'd0;
                hh_units <= 4'd1;
            end else begin
                // Increment hour BCD
                if (hh_units == 4'd9) begin
                    // If units digit is 9 (cannot happen in 12 hour format), reset to 0 (safety)
                    hh_units <= 4'd0;
                    hh_tens  <= hh_tens + 4'd1;
                end else if (hh_units == 4'd2 && hh_tens == 4'd1) begin
                    // Special case not needed since covered by is_hour_12 check
                    hh_units <= 4'd1;
                    hh_tens  <= 4'd0;
                end else begin
                    hh_units <= hh_units + 4'd1;
                end
            end

            // Toggle PM when hour changes from 11 to 12
            if (is_hour_11) begin
                pm <= ~pm;
            end
        end
    end

    // On reset, also reset mm and ss outputs for clarity
    always @(posedge clk) begin
        if (reset) begin
            mm <= 8'd0;
            ss <= 8'd0;
            hh <= 8'd0;
        end else begin
            hh <= {hh_tens, hh_units};
            mm <= {mm_tens, mm_units};
            ss <= {ss_tens, ss_units};
        end
    end

endmodule