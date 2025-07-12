module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate registers for each digit (BCD)
reg [3:0] ss_u, ss_t;
reg [3:0] mm_u, mm_t;
reg [3:0] hh_u, hh_t;

// Helper wire to detect when hours = 11 (BCD "11")
wire hour_is_11 = (hh_t == 4'd1) && (hh_u == 4'd1);

// Helper wire to detect when hours = 12 (BCD "12")
wire hour_is_12 = (hh_t == 4'd1) && (hh_u == 4'd2);

always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00:00 AM
        ss_u <= 4'd0;
        ss_t <= 4'd0;
        mm_u <= 4'd0;
        mm_t <= 4'd0;
        hh_u <= 4'd2; // 12 hours BCD
        hh_t <= 4'd1;
        pm   <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds units
        if (ss_u == 4'd9) begin
            ss_u <= 4'd0;
            // Increment seconds tens
            if (ss_t == 4'd5) begin
                ss_t <= 4'd0;
                // Seconds rolled over: increment minutes units
                if (mm_u == 4'd9) begin
                    mm_u <= 4'd0;
                    // Increment minutes tens
                    if (mm_t == 4'd5) begin
                        mm_t <= 4'd0;
                        // Minutes rolled over: increment hours BCD
                        if (hour_is_12) begin
                            // Roll hours to 1:00
                            hh_t <= 4'd0;
                            hh_u <= 4'd1;
                            pm   <= ~pm; // Toggle AM/PM at 12:00
                        end else if (hh_u == 4'd9) begin
                            // Units digit roll over, increment tens digit
                            hh_u <= 4'd0;
                            hh_t <= hh_t + 4'd1;
                        end else begin
                            // Increment units digit
                            hh_u <= hh_u + 4'd1;
                        end
                    end else begin
                        mm_t <= mm_t + 4'd1;
                    end
                end else begin
                    mm_u <= mm_u + 4'd1;
                end
            end else begin
                ss_t <= ss_t + 4'd1;
            end
        end else begin
            ss_u <= ss_u + 4'd1;
        end
    end
end

// Output assignment from registers (already BCD)
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'b0;
        mm <= 8'b0;
        ss <= 8'b0;
    end else begin
        hh <= {hh_t, hh_u};
        mm <= {mm_t, mm_u};
        ss <= {ss_t, ss_u};
    end
end

endmodule