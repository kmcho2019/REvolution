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
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50 by toggling its value on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10 by toggling its value every 10 clocks
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Generate CLK_1 by toggling its value every 100 clocks
        if (cnt_100 == 6'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule