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
    
    // Shared counter width (covers all divisions)
    localparam CNT_WIDTH = 7;  // enough for DIV_1/2 = 50 counts
    
    // Shared counter
    reg [CNT_WIDTH-1:0] cnt;
    wire cnt_enable = ~RST;
    
    // Clock gating signals
    wire clk_50_en = 1'b1;  // always enabled (divide by 2)
    wire clk_10_en = (cnt % (DIV_10/2) == 0);
    wire clk_1_en = (cnt % (DIV_1/2) == 0);
    
    // Shared counter logic
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt <= 0;
        end else begin
            cnt <= (cnt == (DIV_1/2 - 1)) ? 0 : cnt + 1;
        end
    end

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (clk_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (clk_10_en) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (clk_1_en) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule