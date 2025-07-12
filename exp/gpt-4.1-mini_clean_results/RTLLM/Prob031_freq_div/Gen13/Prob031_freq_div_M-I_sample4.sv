module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100;  // 7-bit counter for divide by 100

    // 50MHz clock: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Shared counter for 10MHz and 1MHz clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else if (cnt_100 == 7'd99) begin
            cnt_100 <= 7'd0;
            CLK_10  <= ~CLK_10;  // Toggle at end of full 100 cycles (every 10MHz half period)
            CLK_1   <= ~CLK_1;    // Toggle at end of full 100 cycles (every 1MHz half period too)
        end else begin
            cnt_100 <= cnt_100 + 7'd1;
            // Toggle CLK_10 at count 49 (half period for 10MHz, which is 5 cycles * 10)
            if (cnt_100 == 7'd49)
                CLK_10 <= ~CLK_10;
            // Toggle CLK_1 at count 49 (half period for 1MHz, 50 cycles)
            if (cnt_100 == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule