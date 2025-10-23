module freq_div(
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
        // Reset all clocks and counters on reset
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 4'd0;
        cnt_100 <= 6'd0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Increment cnt_10 and toggle CLK_10 when cnt_10 reaches 4
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end else begin
            cnt_10 <= cnt_10 + 4'd1;
        end
        
        // Increment cnt_100 and toggle CLK_1 when cnt_100 reaches 49
        if (cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 6'd1;
        end
    end
end

endmodule