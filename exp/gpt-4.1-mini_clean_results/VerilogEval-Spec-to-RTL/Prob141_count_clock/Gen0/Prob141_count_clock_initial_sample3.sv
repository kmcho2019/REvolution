module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to convert binary digit (0-9) to BCD nibble is not needed as we store digits directly.
    // We'll store digits in BCD nibbles directly.

    // Internal registers for digits
    reg [3:0] hh_tens, hh_ones;
    reg [3:0] mm_tens, mm_ones;
    reg [3:0] ss_tens, ss_ones;

    // Increment seconds by one second
    // Roll over logic for seconds, minutes, hours accordingly

    always @(posedge clk) begin
        if (reset) begin
            // Reset time to 12:00 AM
            pm <= 1'b0;
            hh_tens <= 4'd1;  // '1'
            hh_ones <= 4'd2;  // '2' => 12
            mm_tens <= 4'd0;
            mm_ones <= 4'd0;
            ss_tens <= 4'd0;
            ss_ones <= 4'd0;
        end else if (ena) begin
            // Increment seconds
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Increment minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Increment hours

                            // Convert current hh to integer
                            // hh is 01-12 in BCD
                            // We'll convert BCD to number, increment, handle wrap and pm toggle

                            // Convert hh to int
                            integer h;
                            h = hh_tens * 10 + hh_ones;

                            if (h == 11) begin
                                // 11 -> 12 pm toggle
                                h = 12;
                                pm <= ~pm;
                            end else if (h == 12) begin
                                // 12 -> 1
                                h = 1;
                            end else begin
                                h = h + 1;
                            end

                            // Update hh_tens, hh_ones
                            hh_tens <= h / 10;
                            hh_ones <= h % 10;

                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Assign outputs from internal registers
    always @(*) begin
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule