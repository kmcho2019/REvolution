module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [1:0] cnt_10;  // Reduced from 3 bits
    reg [5:0] cnt_100; // Same size but used more efficiently

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 2'b0;
            cnt_100 <= 6'b0;
        end
        else begin
            // 50MHz clock (toggle every cycle)
            CLK_50 <= ~CLK_50;
            
            // Common counter for both 10MHz and 1MHz
            cnt_100 <= cnt_100 + 1'b1;
            
            // 10MHz clock (toggle every 5 cycles)
            if (cnt_100[1:0] == 2'b11) begin  // Equivalent to count==4 when using full counter
                CLK_10 <= ~CLK_10;
            end
            
            // 1MHz clock (toggle every 50 cycles)
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end
        end
    end

endmodule