module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Packed 8-bit BCD seconds and minutes (tens in [7:4], units in [3:0])
    reg [7:0] ss_bcd;
    reg [7:0] mm_bcd;

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Registered output hour BCD to reduce combinational delay and toggling
    reg [7:0] hh_reg;

    // Helper function: increment BCD packed digit (0x00 to 0x59), return rollover flag
    function automatic [8:0] bcd_inc59;
        input [7:0] bcd_in;
        reg [7:0] bcd_next;
        reg carry;
        begin
            // Increment units digit
            if ((bcd_in[3:0] == 4'd9)) begin
                bcd_next[3:0] = 4'd0;
                // Increment tens digit
                if (bcd_in[7:4] == 4'd5) begin
                    bcd_next[7:4] = 4'd0;
                    carry = 1'b1; // rollover past 59
                end else begin
                    bcd_next[7:4] = bcd_in[7:4] + 4'd1;
                    carry = 1'b0;
                end
            end else begin
                bcd_next = bcd_in + 8'd1;
                carry = 1'b0;
            end
            bcd_inc59 = {carry, bcd_next};
        end
    endfunction

    // Convert binary hour (1..12) to BCD
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ss_bcd   <= 8'h00;   // 00 seconds
            mm_bcd   <= 8'h00;   // 00 minutes
            hour_bin <= 4'd12;   // 12 hours
            pm       <= 1'b0;    // AM
            hh_reg   <= 8'h12;   // "12" in BCD
            ss       <= 8'h00;
            mm       <= 8'h00;
            hh       <= 8'h12;
        end else begin
            if (ena) begin
                // Increment seconds BCD, check for rollover
                {wire sec_rollover, ss_bcd} = bcd_inc59(ss_bcd);

                if (sec_rollover) begin
                    // Increment minutes BCD, check for rollover
                    {wire min_rollover, mm_bcd} = bcd_inc59(mm_bcd);

                    if (min_rollover) begin
                        // Increment hour binary (1..12)
                        if (hour_bin == 4'd12)
                            hour_bin <= 4'd1;
                        else
                            hour_bin <= hour_bin + 4'd1;

                        // Toggle pm on 11->12 transition (i.e., when hour_bin was 11 before increment)
                        if (hour_bin == 4'd11)
                            pm <= ~pm;
                    end
                end
            end

            // Update outputs
            ss <= ss_bcd;
            mm <= mm_bcd;

            // Update hh_reg only when hour_bin changes, to reduce output toggling and combinational load
            // Since hour_bin increments only on minute rollover
            // We can detect hour_bin changed if new hh_bcd != previous hh_reg
            // But for simplicity, update hh_reg whenever hour_bin changes
            // Use a separate register to detect hour_bin changes:
            // We'll use a simple approach: update every clk, as this is low toggle cost.
            hh_reg <= bin_to_bcd_hour(hour_bin);
            hh <= hh_reg;
        end
    end

endmodule