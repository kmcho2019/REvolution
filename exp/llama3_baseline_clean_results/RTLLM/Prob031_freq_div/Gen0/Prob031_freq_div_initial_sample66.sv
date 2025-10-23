module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 2'b00;
        cnt_100 <= 6'b000000;
        CLK_1 <= 1'b0;
    end else begin
        CLK_50 <= ~CLK_50;
        
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4'b1000) begin
            cnt_10 <= 4'b0000;
            CLK_10 <= ~CLK_10;
        end
        
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 6'b110001) begin
            cnt_100 <= 6'b000000;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule