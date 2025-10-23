module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Single counter to generate 10 MHz and 1 MHz clocks
    // Maximum count needed is 99 for 1 MHz (toggle every 50 cycles)
    reg [6:0] cnt;  // 7 bits to cover 0..99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt    <= 7'd0;
        end else begin
            // CLK_50 toggles every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // Increment counter for 10 MHz and 1 MHz clocks
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 1'b1;

            // Toggle CLK_10 every 5 cycles (i.e., every 10 input clocks -> divide by 10)
            // Since the counter counts 0..99, toggle CLK_10 at cnt==4,14,24,...,94
            // We can toggle CLK_10 when cnt mod 10 == 4
            if (cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 cycles (i.e., every 100 input clocks -> divide by 100)
            // Toggle CLK_1 at cnt == 49 (half period)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule