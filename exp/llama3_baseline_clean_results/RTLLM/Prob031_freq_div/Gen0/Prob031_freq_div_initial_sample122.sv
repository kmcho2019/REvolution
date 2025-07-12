module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2 = 2'b00;
reg [2:0] cnt_10 = 3'b000;
reg [5:0] cnt_100 = 6'b00000;

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 3'b000;
        cnt_100 <= 6'b00000;
    end else begin
        // For 50MHz
        CLK_50 <= ~CLK_50;
        
        // For 10MHz
        if (cnt_10 == 4'b0100) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // For 1MHz
        if (cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b00000;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule