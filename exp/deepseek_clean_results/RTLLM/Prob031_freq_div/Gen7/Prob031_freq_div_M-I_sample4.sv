module freq_div #(
    parameter DIV_50 = 2,
    parameter DIV_10 = 10,
    parameter DIV_1 = 100
) (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Synchronized reset
    reg RST_sync;
    always @(posedge CLK_in) RST_sync <= RST;

    // Gray code counters
    reg [2:0] cnt_10_gray;
    reg [5:0] cnt_100_gray;
    wire [2:0] cnt_10_bin = {cnt_10_gray[2], ^cnt_10_gray[2:1], ^cnt_10_gray[1:0]};
    wire [5:0] cnt_100_bin = {cnt_100_gray[5], ^cnt_100_gray[5:4], ^cnt_100_gray[4:3],
                             ^cnt_100_gray[3:2], ^cnt_100_gray[2:1], ^cnt_100_gray[1:0]};

    // Clock enables
    wire clk_50_en = 1'b1; // Always enabled
    wire clk_10_en = (cnt_100_bin % (DIV_1/DIV_10)) == 0;
    wire clk_1_en = 1'b1; // Always enabled

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST_sync) begin
        if (RST_sync) begin
            CLK_50 <= 1'b0;
        end else if (clk_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST_sync) begin
        if (RST_sync) begin
            CLK_10 <= 1'b0;
            cnt_10_gray <= 3'b0;
        end else if (clk_10_en) begin
            if (cnt_10_bin == (DIV_10/DIV_50)-1) begin
                CLK_10 <= ~CLK_10;
                cnt_10_gray <= 3'b0;
            end else begin
                cnt_10_gray <= cnt_10_gray + 1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST_sync) begin
        if (RST_sync) begin
            CLK_1 <= 1'b0;
            cnt_100_gray <= 6'b0;
        end else if (clk_1_en) begin
            if (cnt_100_bin == (DIV_1/DIV_50)-1) begin
                CLK_1 <= ~CLK_1;
                cnt_100_gray <= 6'b0;
            end else begin
                cnt_100_gray <= cnt_100_gray + 1;
            end
        end
    end

endmodule