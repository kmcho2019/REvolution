module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10_gray;
    wire [2:0] cnt_10_bin;
    
    // Binary to Gray conversion
    assign cnt_10_bin = {cnt_10_gray[2], 
                        cnt_10_gray[2] ^ cnt_10_gray[1], 
                        cnt_10_gray[1] ^ cnt_10_gray[0]};
    
    // Shared counter for 1MHz clock (divide by 100)
    reg [6:0] shared_cnt;  // Counts 0-99

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10) with Gray code counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10_gray <= 3'b0;
            CLK_10 <= 1'b0;
        end else if (cnt_10_bin == 3'd4) begin
            cnt_10_gray <= 3'b0;
            CLK_10 <= ~CLK_10;
        end else begin
            // Standard binary increment converted to Gray code
            cnt_10_gray <= cnt_10_bin + 1'b1;
            cnt_10_gray[0] <= cnt_10_bin[0] ^ (cnt_10_bin == 3'd0);
            cnt_10_gray[1] <= cnt_10_bin[1] ^ (cnt_10_bin[1:0] == 2'b01);
            cnt_10_gray[2] <= cnt_10_bin[2] ^ (cnt_10_bin[2:0] == 3'b011);
        end
    end

    // CLK_1 generation (divide by 100) with shared counter and clock gating
    wire clk_1_enable = (shared_cnt == 7'd99);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            shared_cnt <= 7'd99;  // Down counter starts at max value
            CLK_1 <= 1'b0;
        end else begin
            if (shared_cnt == 7'd0) begin
                shared_cnt <= 7'd99;
                if (clk_1_enable) begin
                    CLK_1 <= ~CLK_1;
                end
            end else begin
                shared_cnt <= shared_cnt - 1'b1;
            end
        end
    end

endmodule