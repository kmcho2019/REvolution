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

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            hh       <= 8'h12; // BCD 12
            mm       <= 8'h00;
            ss       <= 8'h00;
        end else if (ena) begin
            // Local vars for increments
            reg [3:0] ss_u, ss_t, mm_u, mm_t;
            reg [3:0] hr_bin_next;
            reg       pm_next;
            
            // Initialize from current state
            ss_u = ss_units;
            ss_t = ss_tens;
            mm_u = mm_units;
            mm_t = mm_tens;
            hr_bin_next = hour_bin;
            pm_next = pm;
            
            // Increment seconds
            if (ss_u == 4'd9) begin
                ss_u = 4'd0;
                if (ss_t == 4'd5)
                    ss_t = 4'd0;
                else
                    ss_t = ss_t + 4'd1;
            end else begin
                ss_u = ss_u + 4'd1;
            end
            
            // Check if seconds rolled over
            if ((ss_t == 4'd0) && (ss_u == 4'd0)) begin
                // Increment minutes
                if (mm_u == 4'd9) begin
                    mm_u = 4'd0;
                    if (mm_t == 4'd5)
                        mm_t = 4'd0;
                    else
                        mm_t = mm_t + 4'd1;
                end else begin
                    mm_u = mm_u + 4'd1;
                end
                
                // Check if minutes rolled over
                if ((mm_t == 4'd0) && (mm_u == 4'd0)) begin
                    // Increment hour
                    if (hr_bin_next == 4'd12)
                        hr_bin_next = 4'd1;
                    else
                        hr_bin_next = hr_bin_next + 4'd1;

                    // Toggle pm on hour roll from 11 to 12
                    if (hour_bin == 4'd11)
                        pm_next = ~pm_next;
                end
            end

            // Update registers
            ss_units <= ss_u;
            ss_tens  <= ss_t;
            mm_units <= mm_u;
            mm_tens  <= mm_t;
            hour_bin <= hr_bin_next;
            pm       <= pm_next;

            // Convert binary hour (1..12) to BCD for output
            if (hr_bin_next <= 4'd9) begin
                hh <= {4'd0, hr_bin_next};
            end else begin
                // 10,11,12
                hh <= {4'd1, hr_bin_next - 4'd10};
            end

            mm <= {mm_t, mm_u};
            ss <= {ss_t, ss_u};
        end
        else begin
            // When not enabled, outputs remain stable (no changes)
            // No changes needed as registers hold current state
        end
    end

endmodule