module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Stage 1: 100MHz -> 50MHz (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Stage 2: 50MHz -> 10MHz (divide by 5) with clock gating
    reg [1:0] cnt_5;
    wire clk_10_en = (cnt_5 == 2'd2);

    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_5 <= 2'b0;
            CLK_10 <= 1'b0;
        end else if (clk_10_en) begin
            CLK_10 <= ~CLK_10;
            cnt_5 <= 2'b0;
        end else begin
            cnt_5 <= cnt_5 + 1'b1;
        end
    end

    // Stage 3: 10MHz -> 1MHz (divide by 10) with clock gating
    reg [2:0] cnt_10;
    wire clk_1_en = (cnt_10 == 3'd4);

    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'b0;
            CLK_1 <= 1'b0;
        end else if (clk_1_en) begin
            CLK_1 <= ~CLK_1;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

endmodule