module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Modulo-7 counter
    reg [2:0] cnt_rise;
    reg [2:0] cnt_fall;

    // Intermediate divided clocks toggled on rising and falling edges
    reg clk_div_p; // toggled on rising edge (phase 0)
    reg clk_div_n; // toggled on falling edge (phase shifted by half clk period)

    // Counter increment on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise <= 3'd0;
            clk_div_p <= 1'b0;
        end else begin
            if (cnt_rise == 3'd6)
                cnt_rise <= 3'd0;
            else
                cnt_rise <= cnt_rise + 3'd1;

            // Toggle clk_div_p at counts 0 and 4 (uneven periods: 4 and 3 cycles)
            if ((cnt_rise == 3'd0) || (cnt_rise == 3'd4))
                clk_div_p <= ~clk_div_p;
        end
    end

    // Counter increment on falling edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall <= 3'd0;
            clk_div_n <= 1'b0;
        end else begin
            if (cnt_fall == 3'd6)
                cnt_fall <= 3'd0;
            else
                cnt_fall <= cnt_fall + 3'd1;

            // Toggle clk_div_n at counts 2 and 6 (phase shifted toggling)
            if ((cnt_fall == 3'd2) || (cnt_fall == 3'd6))
                clk_div_n <= ~clk_div_n;
        end
    end

    // Final output: OR of phase-shifted intermediate clocks gives balanced fractional output
    assign clk_div = clk_div_p | clk_div_n;

endmodule