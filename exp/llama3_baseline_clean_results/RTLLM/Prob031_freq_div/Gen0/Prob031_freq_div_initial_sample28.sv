module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // 2-bit counter
reg [3:0] cnt_10;  // 4-bit counter
reg [5:0] cnt_100;  // 6-bit counter

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Increment cnt_10 and toggle CLK_10 when cnt_10 reaches 4
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Increment cnt_100 and toggle CLK_1 when cnt_100 reaches 49
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule