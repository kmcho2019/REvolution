module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_CNT_MAX = 7;

    // Counter counting 0 to 6 on rising edge clk
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Base divided clock generated on rising edge: high for 4 cycles, low for 3 cycles
    reg clk_base_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_base_pos <= 1'b0;
        else if (cnt < 4)
            clk_base_pos <= 1'b1;
        else
            clk_base_pos <= 1'b0;
    end

    // Sample cnt on falling edge
    reg [2:0] cnt_fall;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_fall <= 3'd0;
        else
            cnt_fall <= cnt;
    end

    // Base divided clock generated on falling edge: high for counts 0..3 (same as rising), low else
    reg clk_base_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_base_neg <= 1'b0;
        else if (cnt_fall < 4)
            clk_base_neg <= 1'b1;
        else
            clk_base_neg <= 1'b0;
    end

    // Final output: OR of the two phase-shifted base clocks
    assign clk_div = clk_base_pos | clk_base_neg;

endmodule