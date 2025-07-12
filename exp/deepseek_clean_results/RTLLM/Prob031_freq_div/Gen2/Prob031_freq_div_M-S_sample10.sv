module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [2:0] count10;  // 0-4 counter for 10MHz
    reg [5:0] count100; // 0-49 counter for 1MHz

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            count10 <= 0;
            count100 <= 0;
        end else begin
            // 50MHz generation (toggle every cycle)
            CLK_50 <= ~CLK_50;

            // 10MHz generation (toggle every 5 cycles)
            if (count10 == 4) begin
                CLK_10 <= ~CLK_10;
                count10 <= 0;
            end else begin
                count10 <= count10 + 1;
            end

            // 1MHz generation (toggle every 50 cycles)
            if (count100 == 49) begin
                CLK_1 <= ~CLK_1;
                count100 <= 0;
            end else begin
                count100 <= count100 + 1;
            end
        end
    end

endmodule