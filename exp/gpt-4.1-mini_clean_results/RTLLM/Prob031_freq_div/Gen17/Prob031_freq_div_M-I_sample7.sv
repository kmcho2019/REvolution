module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100; // 7-bit counter for divide by 100 (0 to 99)

    // 50MHz clock: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Shared counter for 10MHz and 1MHz clocks
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (cnt_100 == 7'd99)
                cnt_100 <= 7'd0;
            else
                cnt_100 <= cnt_100 + 1'b1;

            // Toggle CLK_10 at counts 4, 14, 24, ..., 94 (every 10 counts: toggle at count 4 and count 54)
            // Actually, toggle CLK_10 every 5 counts (half-period = 5 cycles)
            if (cnt_100 == 7'd4 || cnt_100 == 7'd54)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 at counts 49 and 99 (half-period = 50 cycles)
            if (cnt_100 == 7'd49 || cnt_100 == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule