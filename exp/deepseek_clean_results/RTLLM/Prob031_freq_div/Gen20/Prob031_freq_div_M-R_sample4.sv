module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter widths based on division factors
    localparam CNT_10_WIDTH = $clog2(DIV_10/2);
    localparam CNT_1_WIDTH = $clog2(DIV_1/2);
    
    // Terminal counts for each divider
    localparam TERM_CNT_10 = (DIV_10/2)-1;
    localparam TERM_CNT_1 = (DIV_1/2)-1;

    // Clock registers
    reg clk_50_reg;
    reg clk_10_reg;
    reg clk_1_reg;
    
    // Counters
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_100;
    
    // Clock enable signals
    wire clk_10_toggle = (cnt_10 == 0);
    wire clk_1_toggle = (cnt_100 == 0);

    // Continuous assignments for clock outputs
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end

    // Counter for CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= TERM_CNT_10;
        end else begin
            if (clk_10_toggle)
                cnt_10 <= TERM_CNT_10;
            else
                cnt_10 <= cnt_10 - 1'b1;
        end
    end

    // CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_10_reg <= 1'b0;
        end else if (clk_10_toggle) begin
            clk_10_reg <= ~clk_10_reg;
        end
    end

    // Counter for CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= TERM_CNT_1;
        end else begin
            if (clk_1_toggle)
                cnt_100 <= TERM_CNT_1;
            else
                cnt_100 <= cnt_100 - 1'b1;
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_1_reg <= 1'b0;
        end else if (clk_1_toggle) begin
            clk_1_reg <= ~clk_1_reg;
        end
    end

endmodule