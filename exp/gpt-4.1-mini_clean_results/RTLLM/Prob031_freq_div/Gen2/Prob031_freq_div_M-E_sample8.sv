module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counters for each frequency divider
    reg [0:0] cnt_2;      // for 50MHz (divide by 2)
    reg [3:0] cnt_10;     // for 10MHz (divide by 10)
    reg [6:0] cnt_100;    // for 1MHz (divide by 100)

    // 50MHz clock divider (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_2 <= 0;
            CLK_50 <= 0;
        end else begin
            if (cnt_2 == 1) begin
                cnt_2 <= 0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_2 <= cnt_2 + 1'b1;
            end
        end
    end

    // 10MHz clock divider (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            if (cnt_10 == 4) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // 1MHz clock divider (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            if (cnt_100 == 49) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule