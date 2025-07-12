module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg [4:0] cnt_10,
    output reg CLK_1,
    output reg [6:0] cnt_100
);

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 5'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 7'b0;
    end else begin
        CLK_50 <= ~CLK_50;
        if (cnt_10 == 5'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 5'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        if (cnt_100 == 7'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule