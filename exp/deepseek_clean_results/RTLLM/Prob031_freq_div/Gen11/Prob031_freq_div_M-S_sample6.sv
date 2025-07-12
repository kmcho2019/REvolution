module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counter for 10MHz clock (divide by 10)
    reg [1:0] cnt_10;  // Counts 0-4 (2 bits sufficient)
    
    // Counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100; // Counts 0-49

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            cnt_10 <= 0;
            CLK_10 <= 0;
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            // 50MHz clock (toggle every cycle)
            CLK_50 <= ~CLK_50;
            
            // 10MHz clock (toggle every 5 cycles)
            if (cnt_10 == 4) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
            
            // 1MHz clock (toggle every 50 cycles)
            if (cnt_100 == 49) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule