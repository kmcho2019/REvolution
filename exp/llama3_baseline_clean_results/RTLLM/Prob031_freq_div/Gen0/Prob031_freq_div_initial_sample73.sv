module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2; // counter for CLK_50
reg [3:0] cnt_10; // counter for CLK_10
reg [5:0] cnt_100; // counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        cnt_2 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        // generate CLK_50 by dividing CLK_in by 2
        if (cnt_2 == 1'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 1'b0;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end
        
        // generate CLK_10 by dividing CLK_in by 10
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // generate CLK_1 by dividing CLK_in by 100
        if (cnt_100 == 6'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule