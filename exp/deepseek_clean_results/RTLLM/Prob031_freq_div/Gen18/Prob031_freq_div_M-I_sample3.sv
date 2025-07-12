module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 5;  // Now relative to 50MHz
    parameter DIV_1 = 10;  // Now relative to 10MHz
    
    // Pre-calculated terminal counts
    localparam TERM_50 = DIV_50 - 1;
    localparam TERM_10 = DIV_10 - 1;
    localparam TERM_1 = DIV_1 - 1;

    // 50MHz clock (divide by 2 from 100MHz)
    reg [0:0] cnt_50;
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50 <= TERM_50;
            clk_50_reg <= 1'b0;
        end else begin
            if (cnt_50 == 0) begin
                cnt_50 <= TERM_50;
                clk_50_reg <= ~clk_50_reg;
            end else begin
                cnt_50 <= cnt_50 - 1'b1;
            end
        end
    end
    assign CLK_50 = clk_50_reg;

    // 10MHz clock (divide by 5 from 50MHz)
    reg [$clog2(DIV_10)-1:0] cnt_10;
    reg clk_10_reg;
    wire clk_10_en = (cnt_50 == 0);  // Only update at 50MHz edges
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= TERM_10;
            clk_10_reg <= 1'b0;
        end else if (clk_10_en) begin
            if (cnt_10 == 0) begin
                cnt_10 <= TERM_10;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // 1MHz clock (divide by 10 from 10MHz)
    reg [$clog2(DIV_1)-1:0] cnt_1;
    reg clk_1_reg;
    wire clk_1_en = (cnt_50 == 0) && (cnt_10 == 0);  // Only update at 10MHz edges
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_1 <= TERM_1;
            clk_1_reg <= 1'b0;
        end else if (clk_1_en) begin
            if (cnt_1 == 0) begin
                cnt_1 <= TERM_1;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_1 <= cnt_1 - 1'b1;
            end
        end
    end
    assign CLK_1 = clk_1_reg;

endmodule