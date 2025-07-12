module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b00;
    end else begin
        if(cnt_2 == 2'b01) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b00;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 4'b0000;
    end else begin
        if(cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0000;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        if(cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule