module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer MUL2_DIV_CLK = 7; // 7 cycles count for 3.5 division

    reg [2:0] cnt;
    reg       div_clk_base;       // Divided clock by 7 with uneven high/low
    reg       div_clk_base_d;     // delayed version of base clock (for posedge clk)
    reg       div_clk_base_q;     // advanced version (for negedge clk)
    
    // Counter counting from 0 to 6 (7 counts total)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == MUL2_DIV_CLK-1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate base divided clock by 7 with duty cycle approx 4 cycles high, 3 cycles low
    // High for cnt = 0,1,2,3; low for cnt=4,5,6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_clk_base <= 1'b0;
        else if (cnt < 4)
            div_clk_base <= 1'b1;
        else
            div_clk_base <= 1'b0;
    end

    // Capture div_clk_base on posedge clk (delayed by clk)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_clk_base_d <= 1'b0;
        else
            div_clk_base_d <= div_clk_base;
    end

    // Capture div_clk_base on negedge clk (advanced by half clk period)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            div_clk_base_q <= 1'b0;
        else
            div_clk_base_q <= div_clk_base;
    end

    // OR two phase-shifted versions to achieve 3.5 division with uniform duty cycle
    assign clk_div = div_clk_base_d | div_clk_base_q;

endmodule