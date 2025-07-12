module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;  // Not needed, instead we will use a simple toggle
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all clocks and counters
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_10 <= 3'b000;
        cnt_100 <= 6'b00000;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if (cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1
        if (cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b00000;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule