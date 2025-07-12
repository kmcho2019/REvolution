module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [2:0] cnt10;  // 3-bit counter for 10MHz (counts 0-4)
    reg [5:0] cnt100; // 6-bit counter for 1MHz (counts 0-49)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt10 <= 0;
            cnt100 <= 0;
        end else begin
            // 50MHz - simple toggle every cycle
            CLK_50 <= ~CLK_50;

            // 10MHz generation (toggle every 5 cycles)
            if (cnt10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 0;
            end else begin
                cnt10 <= cnt10 + 1;
            end

            // 1MHz generation (toggle every 50 cycles)
            if (cnt100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= 0;
            end else begin
                cnt100 <= cnt100 + 1;
            end
        end
    end

endmodule