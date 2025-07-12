module freq_div (
    input  wire        CLK_in,
    input  wire        RST,
    output reg         CLK_50,
    output reg         CLK_10,
    output reg         CLK_1
);

reg [1:0] cnt_2;
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_2   <= 2'b0;
        cnt_10  <= 3'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Generate CLK_50
        if (cnt_2 == 2'd1) begin
            cnt_2   <= 2'b0;
            CLK_50  <= ~CLK_50;
        end else begin
            cnt_2   <= cnt_2 + 1'b1;
        end

        // Generate CLK_10
        if (cnt_10 == 3'd9) begin
            cnt_10  <= 3'b0;
            CLK_10  <= ~CLK_10;
        end else begin
            cnt_10  <= cnt_10 + 1'b1;
        end

        // Generate CLK_1
        if (cnt_100 == 6'd99) begin
            cnt_100 <= 6'b0;
            CLK_1   <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule