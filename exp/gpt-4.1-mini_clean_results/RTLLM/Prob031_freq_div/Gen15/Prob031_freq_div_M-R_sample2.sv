module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters define half-period counts for toggling outputs
    parameter HALF_PERIOD_10  = 5 - 1;   // Toggle every 5 clock cycles (divide by 10)
    parameter HALF_PERIOD_100 = 50 - 1;  // Toggle every 50 clock cycles (divide by 100)

    reg [2:0]  cnt_10, cnt_10_next;
    reg [5:0]  cnt_100, cnt_100_next;

    reg        clk_10_next, clk_1_next;

    // Combinational logic for cnt_10 and CLK_10 next values
    always @(*) begin
        if (cnt_10 == HALF_PERIOD_10) begin
            cnt_10_next = 3'd0;
            clk_10_next = ~CLK_10;
        end else begin
            cnt_10_next = cnt_10 + 1'b1;
            clk_10_next = CLK_10;
        end
    end

    // Combinational logic for cnt_100 and CLK_1 next values
    always @(*) begin
        if (cnt_100 == HALF_PERIOD_100) begin
            cnt_100_next = 6'd0;
            clk_1_next = ~CLK_1;
        end else begin
            cnt_100_next = cnt_100 + 1'b1;
            clk_1_next = CLK_1;
        end
    end

    // Sequential logic for all registers
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            cnt_10  <= 3'd0;
            CLK_10  <= 1'b0;
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;       // Toggle every clock cycle

            cnt_10 <= cnt_10_next;
            CLK_10 <= clk_10_next;

            cnt_100 <= cnt_100_next;
            CLK_1 <= clk_1_next;
        end
    end

endmodule