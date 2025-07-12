module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Master counter (0-99) for all divisions
    reg [6:0] master_cnt;
    wire cnt_full = (master_cnt == 7'd99);
    
    // Clock enable signals
    wire clk_50_en = 1'b1;  // Always enabled (toggle every cycle)
    wire clk_10_en = (master_cnt[2:0] == 3'd4);  // Every 5 cycles
    wire clk_1_en = cnt_full;  // Every 100 cycles
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update master counter
            master_cnt <= cnt_full ? 7'd0 : master_cnt + 1'b1;
            
            // CLK_50 - toggle every cycle (divide by 2)
            if (clk_50_en) CLK_50 <= ~CLK_50;
            
            // CLK_10 - toggle every 5 cycles (divide by 10)
            if (clk_10_en) CLK_10 <= ~CLK_10;
            
            // CLK_1 - toggle every 100 cycles (divide by 100)
            if (clk_1_en) CLK_1 <= ~CLK_1;
        end
    end

endmodule