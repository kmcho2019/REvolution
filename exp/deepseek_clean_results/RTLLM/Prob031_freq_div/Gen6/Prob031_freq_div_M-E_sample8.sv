module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter (0-99)
    reg [6:0] master_cnt;
    wire clk_50_en;
    wire clk_10_en;
    wire clk_1_en;

    // Clock enables
    assign clk_50_en = 1'b1;  // Toggle every cycle
    assign clk_10_en = (master_cnt[2:0] == 3'd4);  // Every 5 cycles
    assign clk_1_en = (master_cnt == 7'd49);       // Every 50 cycles

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 7'b0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end
        else begin
            // Update master counter
            master_cnt <= (master_cnt == 7'd99) ? 7'b0 : master_cnt + 1'b1;

            // Clock generation with enables
            if (clk_50_en) CLK_50 <= ~CLK_50;
            if (clk_10_en) CLK_10 <= ~CLK_10;
            if (clk_1_en) CLK_1 <= ~CLK_1;
        end
    end

endmodule