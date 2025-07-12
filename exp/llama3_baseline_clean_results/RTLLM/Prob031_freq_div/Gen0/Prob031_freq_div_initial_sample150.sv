module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Counter for CLK_50
reg [2:0] cnt_10; // Counter for CLK_10
reg [5:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in, posedge RST) begin
    if (RST) begin
        // Reset all counters and output clock signals
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Toggle CLK_50 every positive edge of CLK_in
        if (cnt_2 == 1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 0;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end
        
        // Toggle CLK_10 every 10 cycles of CLK_in
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Toggle CLK_1 every 100 cycles of CLK_in
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule