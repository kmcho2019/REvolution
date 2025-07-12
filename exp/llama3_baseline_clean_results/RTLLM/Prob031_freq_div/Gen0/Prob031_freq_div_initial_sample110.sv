module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in, posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        CLK_50 <= ~CLK_50; // Toggle on every positive edge
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10; // Toggle when counter reaches 4
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1; // Increment counter
        end
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1; // Toggle when counter reaches 49
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1; // Increment counter
        end
    end
end

endmodule