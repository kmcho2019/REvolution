module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for counts
    localparam DIV_2_COUNT   = 1;   // toggle every 1 clock cycle (divide by 2)
    localparam DIV_10_COUNT  = 5;   // toggle every 5 clock cycles (divide by 10)
    localparam DIV_100_COUNT = 50;  // toggle every 50 clock cycles (divide by 100)

    reg [6:0] cnt; // Enough to count to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt   <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // CLK_50 toggles every 1 count (every posedge)
            if (cnt[0] == 1'b1)  // Equivalent to toggling every clock cycle / 2
                CLK_50 <= ~CLK_50;

            // CLK_10 toggles at counts 4 and 9 in the 0..9 cycle 
            // but to keep simplicity, toggle at every DIV_10_COUNT count
            if ( (cnt % DIV_10_COUNT) == (DIV_10_COUNT - 1) ) 
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles at counts 49 and 99
            if ( (cnt % DIV_100_COUNT) == (DIV_100_COUNT - 1) )
                CLK_1 <= ~CLK_1;
        end
    end

endmodule