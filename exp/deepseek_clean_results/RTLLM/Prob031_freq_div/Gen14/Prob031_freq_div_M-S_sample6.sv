module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz clock (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) CLK_50 <= 0;
        else CLK_50 <= ~CLK_50;
    end

    // 10MHz clock (divide by 10)
    reg [2:0] cnt_10;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end

    // 1MHz clock (divide by 100)
    reg [5:0] cnt_100;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end

endmodule