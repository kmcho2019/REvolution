module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg [3:0] cnt_10,
    output reg [5:0] cnt_100,
    output reg CLK_1
);

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;  // toggle CLK_50 on every positive edge of CLK_in
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;  // toggle CLK_10 when cnt_10 reaches 4
            cnt_10 <= 0;  // reset cnt_10
        end else begin
            cnt_10 <= cnt_10 + 1;  // increment cnt_10
        end
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;  // toggle CLK_1 when cnt_100 reaches 49
            cnt_100 <= 0;  // reset cnt_100
        end else begin
            cnt_100 <= cnt_100 + 1;  // increment cnt_100
        end
    end
end

endmodule