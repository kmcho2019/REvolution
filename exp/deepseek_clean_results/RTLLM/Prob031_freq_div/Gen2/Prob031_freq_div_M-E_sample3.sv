module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared 7-bit counter (counts 0-99)
    reg [6:0] master_cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update master counter
            master_cnt <= (master_cnt == 7'd99) ? 7'd0 : master_cnt + 7'd1;

            // CLK_50 - toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 - toggle every 5 counts (divide by 10)
            if (master_cnt[2:0] == 3'd4) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 - toggle at count 49 (divide by 100)
            if (master_cnt == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule