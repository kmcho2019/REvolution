module freq_div #(
    parameter DIV_50 = 2,
    parameter DIV_10 = 10,
    parameter DIV_1 = 100
)(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counters
    reg [2:0] cnt_10_gray;
    reg [6:0] cnt_100_gray;
    wire [2:0] cnt_10_bin;
    wire [6:0] cnt_100_bin;
    
    // Gray to binary conversion
    assign cnt_10_bin = {cnt_10_gray[2], 
                        cnt_10_gray[2] ^ cnt_10_gray[1], 
                        cnt_10_gray[2] ^ cnt_10_gray[1] ^ cnt_10_gray[0]};
    
    assign cnt_100_bin = {cnt_100_gray[6],
                         cnt_100_gray[6] ^ cnt_100_gray[5],
                         cnt_100_gray[6] ^ cnt_100_gray[5] ^ cnt_100_gray[4],
                         cnt_100_gray[6] ^ cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3],
                         cnt_100_gray[6] ^ cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2],
                         cnt_100_gray[6] ^ cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2] ^ cnt_100_gray[1],
                         cnt_100_gray[6] ^ cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2] ^ cnt_100_gray[1] ^ cnt_100_gray[0]};

    // Clock enable signals
    wire clk_50_en = 1'b1;  // Always enabled
    wire clk_10_en = (cnt_10_bin == (DIV_10/2-1));
    wire clk_1_en = (cnt_100_bin == (DIV_1/2-1));

    // Synchronous reset handling
    reg RST_sync;
    always @(posedge CLK_in) begin
        RST_sync <= RST;
    end

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
        end else begin
            if (cnt_10_bin == (DIV_10-1)) begin
                cnt_10_gray <= 3'b0;
            end else begin
                // Binary to Gray conversion for next value
                cnt_10_gray <= (cnt_10_bin + 1'b1) ^ ((cnt_10_bin + 1'b1) >> 1);
            end
            
            if (clk_10_en) begin
                CLK_10 <= ~CLK_10;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST_sync) begin
        if (RST_sync) begin
            CLK_1 <= 1'b0;
            cnt_100_gray <= 7'b0;
        end else begin
            if (cnt_100_bin == (DIV_1-1)) begin
                cnt_100_gray <= 7'b0;
            end else begin
                // Binary to Gray conversion for next value
                cnt_100_gray <= (cnt_100_bin + 1'b1) ^ ((cnt_100_bin + 1'b1) >> 1);
            end
            
            if (clk_1_en) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule