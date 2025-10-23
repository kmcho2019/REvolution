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
// Hour as binary 1..12
reg [3:0] hour_bin;

always @(posedge clk) begin
    if (reset) begin
        // Reset all counters to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hour_bin <= 4'd12;
        pm       <= 1'b0;
        // Output registers
        hh <= 8'h12; // 0x12 means 12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;

                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;

                        // Increment hour
                        if (hour_bin == 4'd12) begin
                            hour_bin <= 4'd1;
                        end else begin
                            hour_bin <= hour_bin + 4'd1;
                        end

                        // Toggle PM if hour rolls from 11 to 12
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

        // Convert hour_bin to BCD directly in sequential logic
        if (hour_bin <= 4'd9)
            hh <= {4'd0, hour_bin};
        else
            hh <= {4'd1, hour_bin - 4'd10};

        // Pack minutes and seconds
        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end
end

endmodule