module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Enhanced parameters with better documentation
    parameter DIV_50 = 2;      // 100MHz/2 = 50MHz
    parameter DIV_10 = 10;     // 100MHz/10 = 10MHz
    parameter DIV_1 = 100;     // 100MHz/100 = 1MHz
    
    // Calculate counter widths using Gray code optimization
    localparam CNT_BASE_WIDTH = $clog2(DIV_1);
    localparam GRAY_WIDTH = CNT_BASE_WIDTH;
    
    // Terminal counts for each division
    localparam TERM_CNT_50 = DIV_50 - 1;
    localparam TERM_CNT_10 = DIV_10 - 1;
    localparam TERM_CNT_1 = DIV_1 - 1;

    // Gray code counters (reduces switching activity)
    reg [GRAY_WIDTH-1:0] cnt_base;
    wire [GRAY_WIDTH-1:0] cnt_base_next = cnt_base + 1'b1;
    wire [GRAY_WIDTH-1:0] cnt_base_gray = cnt_base ^ (cnt_base >> 1);
    wire [GRAY_WIDTH-1:0] cnt_base_next_gray = cnt_base_next ^ (cnt_base_next >> 1);
    
    // Clock gating control for 1MHz
    reg clk_1_enable;
    wire clk_1_gated = CLK_in & clk_1_enable;

    // Synchronous reset implementation
    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all clocks and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_base <= '0;
            clk_1_enable <= 1'b0;
        end else begin
            // Convert Gray code back to binary for comparison
            integer binary_cnt = 0;
            for (integer i = GRAY_WIDTH-1; i >= 0; i=i-1)
                binary_cnt = binary_cnt ^ (cnt_base_gray >> i);
            
            // CLK_50 generation (divide by 2)
            if (binary_cnt[0]) CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (divide by 10)
            if (binary_cnt == TERM_CNT_10) begin
                CLK_10 <= ~CLK_10;
                clk_1_enable <= 1'b1;  // Enable 1MHz clock gating
            end
            
            // CLK_1 generation (divide by 100) - gated clock
            if (binary_cnt == TERM_CNT_1) begin
                CLK_1 <= ~CLK_1;
                clk_1_enable <= 1'b0;  // Disable until next 10MHz cycle
            end
            
            // Update Gray code counter
            cnt_base <= cnt_base_next_gray;
        end
    end

    // Clock gating implementation
    always @(posedge clk_1_gated or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule