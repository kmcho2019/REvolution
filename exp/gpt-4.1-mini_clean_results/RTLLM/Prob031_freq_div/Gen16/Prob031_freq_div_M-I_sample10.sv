module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100; // 0 to 99 counter for 10MHz and 1MHz generation

    // 50MHz clock: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Single counter for 10MHz and 1MHz clocks
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

            // Toggle CLK_10 at counts 4,14,24,... every 10 counts total half period (divide by 10)
            if ((cnt_100 % 10) == 7'd4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 at count 49 (half period), divide by 100
            if (cnt_100 == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule