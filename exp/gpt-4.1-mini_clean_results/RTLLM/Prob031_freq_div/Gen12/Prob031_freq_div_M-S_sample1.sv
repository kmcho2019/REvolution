module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;

            if (cnt_10 == 4) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else
                cnt_10 <= cnt_10 + 1;

            if (cnt_100 == 49) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end else
                cnt_100 <= cnt_100 + 1;
        end
    end

endmodule