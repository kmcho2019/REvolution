module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100; // 7-bit counter for divide by 100

    // 50MHz clock: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Combined counter for 10MHz and 1MHz generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            if (cnt_100 == 7'd99)
                cnt_100 <= 7'd0;
            else
                cnt_100 <= cnt_100 + 7'd1;

            // Toggle CLK_10 every 5 counts (at cnt_100 == 4,14,24,...,94)
            // Since CLK_10 toggles at count == 4,14,..., which is when (cnt_100 % 10) == 4
            if ((cnt_100 % 10) == 7'd4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 counts (at cnt_100 == 49, 99)
            if (cnt_100 == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule