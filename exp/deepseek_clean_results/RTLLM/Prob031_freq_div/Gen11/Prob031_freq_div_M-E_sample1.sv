module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50 = 0,
    output reg CLK_10 = 0,
    output reg CLK_1 = 0
);

    reg [6:0] master_cnt = 0;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 0;
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Master counter (0-99)
            master_cnt <= (master_cnt == 99) ? 0 : master_cnt + 1;

            // 50MHz - toggle every 1 count (2 total counts per cycle)
            CLK_50 <= master_cnt[0];  // Equivalent to counting mod 2

            // 10MHz - toggle every 5 counts (10 total counts per cycle)
            CLK_10 <= (master_cnt % 10) < 5;

            // 1MHz - toggle every 50 counts (100 total counts per cycle)
            CLK_1 <= master_cnt < 50;
        end
    end

endmodule