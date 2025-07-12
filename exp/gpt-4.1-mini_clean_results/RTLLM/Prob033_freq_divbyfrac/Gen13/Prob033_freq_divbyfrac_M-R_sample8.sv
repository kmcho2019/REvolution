module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // 3-bit counter counts 0 to 6 on rising edge
    reg [2:0] cnt_r;

    // clk_intA is combinationally assigned high for counts 0 to 3 (4 cycles)
    wire clk_intA = (cnt_r <= 3'd3);

    // clk_intA_reg: register clk_intA on rising edge for stable half-cycle delayed generation
    reg clk_intA_reg;

    // clk_intB: delayed clk_intA by half cycle using falling edge trigger
    reg clk_intB;

    // Counter on rising edge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_r <= 3'd0;
        else if (cnt_r == 3'd6)
            cnt_r <= 3'd0;
        else
            cnt_r <= cnt_r + 3'd1;
    end

    // Register clk_intA on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA_reg <= 1'b0;
        else
            clk_intA_reg <= clk_intA;
    end

    // Generate clk_intB on falling edge by sampling registered clk_intA
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else
            clk_intB <= clk_intA_reg;
    end

    // Output clock is OR of clk_intA and clk_intB to achieve fractional division by 3.5
    assign clk_div = clk_intA | clk_intB;

endmodule