module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Local parameters for count limits
    localparam CNT_10_MAX  = 3'd4;   // toggle every 5 cycles
    localparam CNT_100_MAX = 6'd49;  // toggle every 50 cycles
    localparam CNT_2_MAX   = 1'd0;   // toggle every 1 cycle (divide by 2)

    reg [2:0] cnt_10;    // 3-bit counter for divide by 10
    reg [5:0] cnt_100;   // 6-bit counter for divide by 100
    reg       cnt_2;     // 1-bit counter for divide by 2 (toggle every 2 cycles)

    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset all counters and outputs synchronously
            cnt_2   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Divide-by-2 (50 MHz) counter and toggle
            cnt_2 <= ~cnt_2;
            if (cnt_2 == CNT_2_MAX)
                CLK_50 <= ~CLK_50;

            // Divide-by-10 (10 MHz) counter and toggle
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // Divide-by-100 (1 MHz) counter and toggle
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule