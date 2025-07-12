module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1  = 100;
    
    // Master counter width (log2 of largest division)
    localparam CNT_WIDTH = $clog2(DIV_1);
    reg [CNT_WIDTH-1:0] master_cnt;

    // Master counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 0;
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Increment master counter
            if (master_cnt == DIV_1-1)
                master_cnt <= 0;
            else
                master_cnt <= master_cnt + 1;

            // Generate CLK_50 (toggle every DIV_50/2 counts)
            if (master_cnt[0] == 1'b1)
                CLK_50 <= ~CLK_50;

            // Generate CLK_10 (toggle when mod 5 == 4)
            if ((master_cnt % (DIV_10/2)) == (DIV_10/2)-1)
                CLK_10 <= ~CLK_10;

            // Generate CLK_1 (toggle when mod 50 == 49)
            if (master_cnt == (DIV_1/2)-1 || master_cnt == DIV_1-1)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule