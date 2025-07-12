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

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; // Valid range: 1 to 12

always @(posedge clk) begin
    if (reset) begin
        // Reset all counters and outputs
        ss_units  <= 4'd0;
        ss_tens   <= 4'd0;
        mm_units  <= 4'd0;
        mm_tens   <= 4'd0;
        hour_bin  <= 4'd12; // 12 o'clock on reset
        pm        <= 1'b0;  // AM
        hh        <= 8'h12; // BCD 12
        mm        <= 8'h00;
        ss        <= 8'h00;
    end else if (ena) begin
        // Seconds increment logic
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Minutes increment logic on seconds rollover
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Hour increment logic on minutes rollover
                        if (hour_bin == 4'd12) begin
                            hour_bin <= 4'd1;
                        end else begin
                            hour_bin <= hour_bin + 4'd1;
                        end
                        // PM toggle when hour transitions from 11 to 12
                        if (hour_bin == 4'd11)
                            pm <= ~pm;
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

        // Convert hour_bin (1 to 12) to BCD and update outputs
        if (hour_bin <= 4'd9) begin
            hh <= {4'd0, hour_bin};  // 0X
        end else begin
            // 10 to 12
            hh <= {4'd1, hour_bin - 4'd10};
        end

        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end
end

endmodule