module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt;  // 7-bit counter to count from 0 to 99

    always @(posedge CLK_in) begin
        if (RST) begin
            cnt   <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 1'b1;

            // Generate CLK_50 (50MHz): toggle at half period (every 50 counts)
            if (cnt == 7'd49)
                CLK_50 <= ~CLK_50;

            // Generate CLK_10 (10MHz): toggle every 5 counts (half period 5)
            if ((cnt % 10) == 7'd4)
                CLK_10 <= ~CLK_10;

            // Generate CLK_1 (1MHz): toggle every 50 counts (half period 50)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule