module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Master counter parameters
    parameter MASTER_COUNT = 100; // LCM of all division ratios
    parameter CNT_WIDTH = $clog2(MASTER_COUNT);
    
    // Division thresholds
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Master counter
    reg [CNT_WIDTH-1:0] master_cnt;
    
    // Clock generation logic
    always @(posedge CLK_in) begin
        if (RST) begin
            master_cnt <= 0;
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Update master counter
            if (master_cnt == MASTER_COUNT-1)
                master_cnt <= 0;
            else
                master_cnt <= master_cnt + 1;
            
            // Generate CLK_50 (toggle every 50 counts)
            if (master_cnt % (MASTER_COUNT/DIV_50) == 0)
                CLK_50 <= ~CLK_50;
            
            // Generate CLK_10 (toggle every 10 counts)
            if (master_cnt % (MASTER_COUNT/DIV_10) == 0)
                CLK_10 <= ~CLK_10;
            
            // Generate CLK_1 (toggle every 100 counts)
            if (master_cnt % (MASTER_COUNT/DIV_1) == 0)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule