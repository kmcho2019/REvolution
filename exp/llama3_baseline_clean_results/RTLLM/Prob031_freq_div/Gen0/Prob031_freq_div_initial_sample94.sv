module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg [1:0] cnt_10, // Declare cnt_10 as a 2-bit reg to count up to 4
    output reg CLK_1,
    output reg [5:0] cnt_100 // Declare cnt_100 as a 6-bit reg to count up to 49
    );

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end
    else begin
        CLK_50 <= ~CLK_50;
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        else
            cnt_10 <= cnt_10 + 1;
        
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
        else
            cnt_100 <= cnt_100 + 1;
    end
end

endmodule