module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate counter widths and terminal counts
    localparam CNT_WIDTH = $clog2(DIV_1/2);
    localparam TERM_CNT_10 = (DIV_10/2)-1;
    localparam TERM_CNT_1 = (DIV_1/2)-1;

    // Shared counter
    reg [CNT_WIDTH-1:0] cnt;
    wire cnt_enable = (cnt != 0) || (CLK_10 == 1'b0) || (CLK_1 == 1'b0);

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Shared counter for CLK_10 and CLK_1
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt <= TERM_CNT_1;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else if (cnt_enable) begin
            if (cnt == 0) begin
                cnt <= TERM_CNT_1;
                CLK_1 <= ~CLK_1;
                if (CLK_1) CLK_10 <= ~CLK_10;
            end else begin
                cnt <= cnt - 1'b1;
                if (cnt == (TERM_CNT_1 - TERM_CNT_10)) begin
                    CLK_10 <= ~CLK_10;
                end
            end
        end
    end

endmodule