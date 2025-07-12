module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal BCD counters for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;
    reg [3:0] hour_bin; // 1 to 12 binary hour counter

    always @(posedge clk) begin
        if (reset) begin
            // Reset time to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            ss       <= 8'd0;
            mm       <= 8'd0;
            hh       <= 8'd0;
        end else if (ena) begin
            // Seconds increment
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Minutes increment
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Hour increment
                            if (hour_bin == 4'd12) begin
                                hour_bin <= 4'd1;
                            end else begin
                                hour_bin <= hour_bin + 4'd1;
                            end
                            // Toggle pm when hour rolls from 11 to 12
                            if (hour_bin == 4'd11) begin
                                pm <= ~pm;
                            end
                        end else begin
                            mm_tens <= mm_tens + 4'd1;
                        end
                    end else begin
                        mm_units <= mm_units + 4'd1;
                    end
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end
            // Update outputs
            ss <= {ss_tens, ss_units};
            mm <= {mm_tens, mm_units};
            // Convert hour_bin to BCD output without subtraction
            if (hour_bin >= 10) begin
                hh <= {4'd1, hour_bin - 4'd10};
            end else begin
                hh <= {4'd0, hour_bin};
            end
        end
    end

endmodule