module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] counter;  // 0-99 counter for both 10MHz and 1MHz

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            counter <= 0;
        end else begin
            // 50MHz generation (toggle every cycle)
            CLK_50 <= ~CLK_50;
            
            // Shared counter for both 10MHz and 1MHz
            counter <= (counter == 99) ? 0 : counter + 1;
            
            // 10MHz generation (toggle every 5 cycles)
            if (counter[2:0] == 4) CLK_10 <= ~CLK_10;
            
            // 1MHz generation (toggle every 50 cycles)
            if (counter == 49) CLK_1 <= ~CLK_1;
        end
    end

endmodule