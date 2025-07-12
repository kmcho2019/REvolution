module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2; // counter for CLK_50
reg [2:0] cnt_10; // counter for CLK_10
reg [5:0] cnt_100; // counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        // CLK_50 generation
        CLK_50 <= ~CLK_50;
        
        // CLK_10 generation
        cnt_10 <= cnt_10 + 1;
        if(cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end
        
        // CLK_1 generation
        cnt_100 <= cnt_100 + 1;
        if(cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule