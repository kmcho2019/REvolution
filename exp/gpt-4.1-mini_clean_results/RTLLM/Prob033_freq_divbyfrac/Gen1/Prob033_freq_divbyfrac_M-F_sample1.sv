module freq_divbyfrac (
    input  wire clk,     // Input clock
    input  wire rst_n,   // Active low reset
    output wire clk_div  // Fractionally divided clock output
);

    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt;         // Single counter running on posedge clk, range 0..6
    reg       div_clk_rise; // Divided clock based on counter
    reg       div_clk_fall; // Phase shifted divided clock sampled on negedge

    // Counter increments on rising edge and resets when reaching 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            div_clk_rise <= 1'b0;
        end else begin
            if (cnt == MUL2_DIV_CLK - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // High for 4 cycles, low for 3 cycles (3.5 division)
            div_clk_rise <= (cnt < 4) ? 1'b1 : 1'b0;
        end
    end

    // On falling edge, sample div_clk_rise to create phase-shifted clock
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_fall <= 1'b0;
        end else begin
            div_clk_fall <= div_clk_rise;
        end
    end

    // OR the two phase-shifted clocks for final fractional clock output
    assign clk_div = div_clk_rise | div_clk_fall;

endmodule