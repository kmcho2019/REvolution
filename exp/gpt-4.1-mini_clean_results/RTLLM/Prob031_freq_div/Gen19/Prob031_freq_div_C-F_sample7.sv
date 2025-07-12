module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters: toggle counts for half periods
    localparam HALF_PERIOD_10  = 3'd4;   // toggle CLK_10 at count 4 (5 cycles)
    localparam HALF_PERIOD_100 = 6'd49;  // toggle CLK_1 at count 49 (50 cycles)

    // Counters
    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    // Next-state signals
    reg [2:0] cnt_10_next;
    reg [5:0] cnt_100_next;
    reg       clk_10_next;
    reg       clk_1_next;

    // Combinational next-state logic for CLK_10 and cnt_10
    always @(*) begin
        if (cnt_10 == HALF_PERIOD_10) begin
            cnt_10_next = 3'd0;
            clk_10_next = ~CLK_10;
        end else begin
            cnt_10_next = cnt_10 + 1'b1;
            clk_10_next = CLK_10;
        end
    end

    // Combinational next-state logic for CLK_1 and cnt_100
    always @(*) begin
        if (cnt_100 == HALF_PERIOD_100) begin
            cnt_100_next = 6'd0;
            clk_1_next = ~CLK_1;
        end else begin
            cnt_100_next = cnt_100 + 1'b1;
            clk_1_next = CLK_1;
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50MHz clock: toggle every input clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Update 10MHz clock and counter
            cnt_10 <= cnt_10_next;
            CLK_10 <= clk_10_next;

            // Update 1MHz clock and counter
            cnt_100 <= cnt_100_next;
            CLK_1  <= clk_1_next;
        end
    end

endmodule