module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // The maximum count needed is for the 1 MHz output, half period = 50 cycles.
    // We'll use a free-running counter from 0 to 99 to cover 1 MHz full period, and toggle CLK_1 at 49.
    // For 10 MHz, toggle at counts 4 and 9 (half period 5 cycles).
    // For 50 MHz, toggle every 1 cycle (half period 1).

    reg [6:0] counter; // 0 to 99 fits in 7 bits

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every 1 count (half period)
            if (counter[0] == 1'b1)
                CLK_50 <= ~CLK_50;

            // CLK_10 toggles at counts 4 and 9 (half period = 5)
            if (counter == 7'd4 || counter == 7'd9)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles at count 49 (half period = 50)
            if (counter == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule