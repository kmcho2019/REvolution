module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Single counter max count: 99 (for divide by 100)
    reg [6:0] cnt; // 7-bit counter covers 0..99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment and wrap counter at 99
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 1'b1;

            // Toggle CLK_50 every 1 count (half period = 1)
            // Toggle at cnt = 0 to get 50MHz with 50% duty cycle
            if (cnt == 7'd0)
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 counts (half period = 5)
            // Toggle at cnt = 4, 9, 14, ... (cnt % 10 == 4)
            if (cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 counts (half period = 50)
            // Toggle at cnt = 49 and 99
            if (cnt == 7'd49 || cnt == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule