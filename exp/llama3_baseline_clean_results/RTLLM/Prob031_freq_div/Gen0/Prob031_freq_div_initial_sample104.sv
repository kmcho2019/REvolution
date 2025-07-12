module freq_div (
    input         CLK_in,
    input         RST,
    output        CLK_50,
    output        CLK_10,
    output        CLK_1
);

reg     CLK_50;
reg     CLK_10;
reg     CLK_1;
reg [1:0]  cnt_2;
reg [3:0]  cnt_10;
reg [5:0]  cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_2  <= 2'b0;
    end else begin
        if (cnt_2 == 2'd1) begin
            CLK_50 <= ~CLK_50;
            cnt_2  <= 2'b0;
        end else begin
            cnt_2  <= cnt_2 + 1'b1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 4'b0;
    end else begin
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        if (cnt_100 == 6'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule