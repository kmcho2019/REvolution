module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Localparams for max counter values (zero-based)
    localparam CNT_10_MAX  = 4;   // counts 0 to 4 for half-period (5 cycles)
    localparam CNT_100_MAX = 49;  // counts 0 to 49 for half-period (50 cycles)

    // Registers for counters
    reg [2:0]  cnt_10, cnt_10_next;
    reg [5:0]  cnt_100, cnt_100_next;

    // Next state signals for clock outputs
    reg clk_10_next, clk_1_next;

    // Combinational logic for CLK_10 counter and toggle
    always @(*) begin
        if (cnt_10 == CNT_10_MAX) begin
            cnt_10_next = 3'd0;
            clk_10_next = ~CLK_10;
        end else begin
            cnt_10_next = cnt_10 + 1'b1;
            clk_10_next = CLK_10;
        end
    end

    // Combinational logic for CLK_1 counter and toggle
    always @(*) begin
        if (cnt_100 == CNT_100_MAX) begin
            cnt_100_next = 6'd0;
            clk_1_next = ~CLK_1;
        end else begin
            cnt_100_next = cnt_100 + 1'b1;
            clk_1_next = CLK_1;
        end
    end

    // Sequential logic: counters and outputs with asynchronous reset
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            cnt_10  <= 3'd0;
            CLK_10  <= 1'b0;
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else begin
            // Toggle CLK_50 every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Update 10MHz counter and clock
            cnt_10 <= cnt_10_next;
            CLK_10 <= clk_10_next;

            // Update 1MHz counter and clock
            cnt_100 <= cnt_100_next;
            CLK_1 <= clk_1_next;
        end
    end

endmodule