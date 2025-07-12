module freq_div (
    input  CLK_in,
    input  RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2 = 0;  // Counter for CLK_50, not actually needed as per logic
reg [2:0] cnt_10 = 0; // Counter for CLK_10
reg [5:0] cnt_100 = 0; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Initialize all clocks and counters when reset is active
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10 by dividing CLK_in by 10
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        
        // Generate CLK_1 by dividing CLK_in by 100
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule