module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;     // 3-bit counter from 0 to 6
    reg       clk_div_p;   // Base divided clock, high 4 cycles, low 3 cycles
    reg       toggle_n;    // Toggle flip-flop clocked on negedge clk

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Generate base divided clock: high for counts 0-3 (4 cycles), low for 4-6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_p <= 1'b0;
        else if (counter <= 3'd3)
            clk_div_p <= 1'b1;
        else
            clk_div_p <= 1'b0;
    end

    // Toggle flip-flop on negedge clk to generate half-cycle shifted signal
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            toggle_n <= 1'b0;
        else
            toggle_n <= ~toggle_n;
    end

    // Final fractional clock: OR of base clock and half-cycle shifted toggle
    assign clk_div = clk_div_p | toggle_n;

endmodule