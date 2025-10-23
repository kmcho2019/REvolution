module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    localparam DIV_10 = 4;  // 100MHz/10MHz/2 - 1
    localparam DIV_100 = 49; // 100MHz/1MHz/2 - 1

    reg [2:0] cnt_10 = 0;
    reg [5:0] cnt_100 = 0;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // 50MHz clock (toggle every cycle)
            CLK_50 <= ~CLK_50;
            
            // 10MHz clock (toggle every 5 cycles)
            cnt_10 <= (cnt_10 == DIV_10) ? 0 : cnt_10 + 1;
            if (cnt_10 == DIV_10) CLK_10 <= ~CLK_10;
            
            // 1MHz clock (toggle every 50 cycles)
            cnt_100 <= (cnt_100 == DIV_100) ? 0 : cnt_100 + 1;
            if (cnt_100 == DIV_100) CLK_1 <= ~CLK_1;
        end
    end

endmodule