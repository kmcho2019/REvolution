module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Master counter width (covers all division ratios)
    parameter MASTER_CNT_WIDTH = 7; // 0-99 needs 7 bits
    reg [MASTER_CNT_WIDTH-1:0] master_cnt;
    
    // Gray code conversion
    wire [MASTER_CNT_WIDTH-1:0] gray_cnt;
    assign gray_cnt = master_cnt ^ (master_cnt >> 1);

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 0;
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Update master counter (0-99 cycle)
            master_cnt <= (master_cnt == 99) ? 0 : master_cnt + 1;
            
            // CLK_50: toggle every 50 cycles (100MHz/2 = 50MHz)
            if (master_cnt[0] == 1'b1) CLK_50 <= ~CLK_50;
            
            // CLK_10: toggle every 5 master_cnt wraps (100MHz/10 = 10MHz)
            if (master_cnt == 9 || master_cnt == 19 || 
                master_cnt == 29 || master_cnt == 39 ||
                master_cnt == 49 || master_cnt == 59 ||
                master_cnt == 69 || master_cnt == 79 ||
                master_cnt == 89 || master_cnt == 99) begin
                CLK_10 <= ~CLK_10;
            end
            
            // CLK_1: toggle at specific points (100MHz/100 = 1MHz)
            if (master_cnt == 49 || master_cnt == 99) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule