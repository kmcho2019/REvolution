module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 6-bit counter (counts 0-99)
    reg [5:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt <= 0;
        end else begin
            // Toggle CLK_50 every cycle (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // Increment counter
            cnt <= (cnt == 99) ? 0 : cnt + 1;
            
            // Toggle CLK_10 every 5 cycles (at count 4)
            if (cnt == 4) CLK_10 <= ~CLK_10;
            
            // Toggle CLK_1 every 50 cycles (at count 49)
            if (cnt == 49) CLK_1 <= ~CLK_1;
        end
    end

endmodule