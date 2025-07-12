module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters define half-period counts for toggling outputs
    localparam HALF_PERIOD_50  = 1 - 1;   // Toggle every 1 clock cycle (divide by 2)
    localparam HALF_PERIOD_10  = 5 - 1;   // Toggle every 5 clock cycles (divide by 10)
    localparam HALF_PERIOD_100 = 50 - 1;  // Toggle every 50 clock cycles (divide by 100)

    reg [2:0]  cnt_10;    // 3-bit counter (0 to 4)
    reg [5:0]  cnt_100;   // 6-bit counter (0 to 49)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50 MHz clock: toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10 MHz clock: toggle every 5 cycles (0 to 4)
            if (cnt_10 == HALF_PERIOD_10) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1 MHz clock: toggle every 50 cycles (0 to 49)
            if (cnt_100 == HALF_PERIOD_100) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule