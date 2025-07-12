module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 10MHz counter (divide by 10)
    reg [2:0] cnt_10;  // 3-bit counter (0-4)

    // 1MHz counter (divide by 100)
    reg [5:0] cnt_100; // 6-bit counter (0-49)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // 50MHz clock - toggle every cycle
            CLK_50 <= ~CLK_50;

            // 10MHz clock logic
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // 1MHz clock logic
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule