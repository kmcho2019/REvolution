module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterized division counts (half counts for toggling)
    localparam DIV_50_HALF  = 1 - 1;   // Toggle every clock (divide by 2)
    localparam DIV_10_HALF  = 5 - 1;   // Toggle every 5 cycles (divide by 10)
    localparam DIV_100_HALF = 50 - 1;  // Toggle every 50 cycles (divide by 100)

    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50 MHz output: toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10 MHz output: toggle every 5 cycles (count 0 to 4)
            if (cnt_10 == DIV_10_HALF) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1 MHz output: toggle every 50 cycles (count 0 to 49)
            if (cnt_100 == DIV_100_HALF) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule