module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz clock generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz clock generation (divide by 10)
    reg [2:0] cnt_10;
    wire en_10 = (cnt_10 == 3'd4);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'b0;
        end else begin
            if (en_10) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // 1MHz clock generation (divide by 100) with Gray counter
    reg [5:0] cnt_100_gray;
    wire [5:0] cnt_100_bin = {cnt_100_gray[5],
                             cnt_100_gray[5] ^ cnt_100_gray[4],
                             cnt_100_gray[4] ^ cnt_100_gray[3],
                             cnt_100_gray[3] ^ cnt_100_gray[2],
                             cnt_100_gray[2] ^ cnt_100_gray[1],
                             cnt_100_gray[1] ^ cnt_100_gray[0]};
    wire en_100 = (cnt_100_bin == 6'd49);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100_gray <= 6'b0;
        end else begin
            if (en_100) begin
                CLK_1 <= ~CLK_1;
                cnt_100_gray <= 6'b0;
            end else begin
                // Standard binary to gray conversion for next value
                cnt_100_gray <= (cnt_100_bin + 1'b1) ^ ((cnt_100_bin + 1'b1) >> 1);
            end
        end
    end

endmodule