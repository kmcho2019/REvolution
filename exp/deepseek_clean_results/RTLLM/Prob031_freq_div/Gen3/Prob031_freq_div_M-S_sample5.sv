module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Combined counter for both 10MHz and 1MHz clocks
    reg [6:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all clocks and counter
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt <= 7'b0;
        end
        else begin
            // 50MHz clock (toggle every cycle)
            CLK_50 <= ~CLK_50;
            
            // Update combined counter
            cnt <= (cnt == 7'd99) ? 7'b0 : cnt + 1'b1;
            
            // 10MHz clock (toggle every 5 cycles)
            if (cnt[2:0] == 3'd4) begin
                CLK_10 <= ~CLK_10;
            end
            
            // 1MHz clock (toggle every 50 cycles)
            if (cnt == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule