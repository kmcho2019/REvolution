module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Not needed as we can simply toggle the CLK_50 on every positive edge of CLK_in
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b000;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end
    else begin
        CLK_50 <= ~CLK_50;  // Toggling CLK_50 on every positive edge of CLK_in
        if(cnt_10 == 4'd4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end
        else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        if(cnt_100 == 6'd50) begin  // 100/2 = 50, and 50/2 = 25, then 100/50 = 2 and then 100/2 = 50, so we will have 50
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end
        else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule