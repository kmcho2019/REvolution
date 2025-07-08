module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for 3.5 division: multiply by 2, divide by 7
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt_r;
    reg       div_clk_pos;  // Divided clock sampled on posedge clk
    reg       div_clk_neg;  // Divided clock sampled on negedge clk

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_r <= 3'd0;
        end else begin
            if (cnt_r == (MUL2_DIV_CLK - 1))
                cnt_r <= 3'd0;
            else
                cnt_r <= cnt_r + 3'd1;
        end
    end

    // Generate divided clock for posedge clock domain
    // High for counts 0..3 (4 cycles), low for counts 4..6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_pos <= 1'b0;
        end else begin
            if (cnt_r < 4)
                div_clk_pos <= 1'b1;
            else
                div_clk_pos <= 1'b0;
        end
    end

    // Generate divided clock for negedge clock domain
    // Need a negedge counter, so create delayed counter by one clk cycle
    reg [2:0] cnt_r_d;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_r_d <= 3'd0;
        end else begin
            if (cnt_r_d == (MUL2_DIV_CLK - 1))
                cnt_r_d <= 3'd0;
            else
                cnt_r_d <= cnt_r_d + 3'd1;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_neg <= 1'b0;
        end else begin
            if (cnt_r_d < 4)
                div_clk_neg <= 1'b1;
            else
                div_clk_neg <= 1'b0;
        end
    end

    // OR both phase-shifted clocks to get fractional divided clock output
    assign clk_div = div_clk_pos | div_clk_neg;

endmodule