module freq_div (
    input  wire        CLK_in,
    input  wire        RST,
    output reg         CLK_50,
    output reg         CLK_10,
    output reg         CLK_1
);

reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [6:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 4'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 7'b0;
    end else begin
        // Generate 50MHz clock signal
        if (cnt_2 == 2'b1) begin
            cnt_2 <= 2'b0;
            CLK_50 <= ~CLK_50;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end

        // Generate 10MHz clock signal
        if (cnt_10 == 4'b1000) begin
            cnt_10 <= 4'b0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end

        // Generate 1MHz clock signal
        if (cnt_100 == 7'b110001) begin
            cnt_100 <= 7'b0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule