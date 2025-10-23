module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2 = 2'b00;  // Counter for CLK_50
reg [2:0] cnt_10 = 3'b000;  // Counter for CLK_10
reg [5:0] cnt_100 = 6'b000000;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all output clocks and counters
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b00;
        cnt_10 <= 3'b000;
        cnt_100 <= 6'b000000;
    end else begin
        // Toggle CLK_50 every clock cycle
        CLK_50 <= ~CLK_50;

        // Toggle CLK_10 every 10 clock cycles
        cnt_10 <= cnt_10 + 1'b1;
        if (cnt_10 == 3'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end

        // Toggle CLK_1 every 100 clock cycles
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 6'd99) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end
    end
end

endmodule