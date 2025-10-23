module TopModule(
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output [7:0]    hh,
    output [7:0]    mm,
    output [7:0]    ss
);

    reg [7:0] hh_reg;
    reg [7:0] mm_reg;
    reg [7:0] ss_reg;
    reg         pm_reg;

    // Counter to generate a signal that pulses once per second
    reg [31:0] second_counter;
    reg         second_pulse;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00 AM
            hh_reg <= 8'b00010010; // BCD for 12
            mm_reg <= 8'b00000000; // BCD for 00
            ss_reg <= 8'b00000000; // BCD for 00
            pm_reg <= 1'b0; // AM
            second_counter <= 32'd0;
        end else begin
            second_counter <= second_counter + 1;
            if (second_counter == 32'd100000000) begin // Assuming clk is 100 MHz
                second_counter <= 32'd0;
                second_pulse <= 1'b1;
            end else begin
                second_pulse <= 1'b0;
            end

            if (second_pulse && ena) begin
                // Update seconds
                if (ss_reg == 8'b00000000 || ss_reg == 8'b00100101) begin // Wrap around 00 to 59
                    ss_reg <= ss_reg + 1;
                end else if (ss_reg == 8'b00111001) begin // 59 to 00
                    ss_reg <= 8'b00000000;
                    // Update minutes
                    if (mm_reg == 8'b00000000 || mm_reg == 8'b00100101) begin
                        mm_reg <= mm_reg + 1;
                    end else if (mm_reg == 8'b00111001) begin
                        mm_reg <= 8'b00000000;
                        // Update hours
                        if (hh_reg == 8'b00010010 || hh_reg == 8'b00010011) begin // 12 to 01
                            hh_reg <= 8'b00010001; // Wrap around 12 to 01
                            pm_reg <= ~pm_reg; // Toggle AM/PM
                        end else if (hh_reg == 8'b00001101) begin // 11 to 12
                            hh_reg <= 8'b00010010;
                            pm_reg <= ~pm_reg; // Toggle AM/PM
                        end else begin
                            hh_reg <= hh_reg + 1;
                        end
                    end
                end
            end
        end
    end

    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;
    assign pm = pm_reg;

endmodule