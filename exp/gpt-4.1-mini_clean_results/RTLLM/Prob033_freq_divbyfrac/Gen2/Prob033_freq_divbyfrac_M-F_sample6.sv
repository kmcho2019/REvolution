module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;

    // Counter for posedge clock domain (counts 0 to 6)
    reg [2:0] cnt_pos;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == CNT_MAX - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // Counter for negedge clock domain (counts 0 to 6)
    reg [2:0] cnt_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == CNT_MAX - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // Base clock pattern: high for counts 0 to 3 (4 cycles), low for counts 4 to 6 (3 cycles)
    wire base_clk_pos = (cnt_pos < 4);
    wire base_clk_neg = (cnt_neg < 4);

    // Registers to hold the signals synchronized to posedge and negedge clk
    reg base_clk_reg;
    reg shifted_clk_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            base_clk_reg <= 1'b0;
        else
            base_clk_reg <= base_clk_pos;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            shifted_clk_reg <= 1'b0;
        else
            shifted_clk_reg <= base_clk_neg;
    end

    // OR the two phase-shifted signals to generate the fractional divided clock
    assign clk_div = base_clk_reg | shifted_clk_reg;

endmodule