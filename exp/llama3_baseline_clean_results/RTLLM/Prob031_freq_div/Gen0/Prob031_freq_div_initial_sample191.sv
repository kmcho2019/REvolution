module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Counter for CLK_50 is not needed, it's just a toggle
reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;  // Toggle CLK_50 on every positive edge of CLK_in
        
        cnt_10 <= cnt_10 + 1;  // Increment counter for CLK_10
        if (cnt_10 == 4'd9) begin  // If counter reaches 10 (4'd9 + 1), toggle CLK_10 and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        
        cnt_100 <= cnt_100 + 1;  // Increment counter for CLK_1
        if (cnt_100 == 6'd99) begin  // If counter reaches 100 (6'd99 + 1), toggle CLK_1 and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule