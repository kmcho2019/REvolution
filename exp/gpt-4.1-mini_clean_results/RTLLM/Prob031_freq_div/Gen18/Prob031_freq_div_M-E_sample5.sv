module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Single shared counter counts 0 to 99 for 100MHz clock
    reg [6:0] cnt;  // 7 bits to cover up to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt   <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter or reset after 99
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // Toggle CLK_50 every count (toggle every 1 clock cycle) -> divide by 2
            // Since toggling every clock means period of 2 input clocks (50MHz from 100MHz)
            CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 counts (at cnt == 4, 9, 14, ...)
            if (cnt[2:0] == 3'd4) // 4 mod 5 (counting from 0 to 4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 counts (at cnt == 49)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule