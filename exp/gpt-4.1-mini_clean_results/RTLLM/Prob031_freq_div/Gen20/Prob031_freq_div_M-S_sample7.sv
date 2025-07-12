module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter max values (zero-based)
    localparam CNT_10_MAX  = 4;   // half period for 10MHz (5 cycles)
    localparam CNT_100_MAX = 49;  // half period for 1MHz (50 cycles)

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
            // Toggle 50MHz clock every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10MHz clock divider
            if (cnt_10 == CNT_10_MAX) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1MHz clock divider
            if (cnt_100 == CNT_100_MAX) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule