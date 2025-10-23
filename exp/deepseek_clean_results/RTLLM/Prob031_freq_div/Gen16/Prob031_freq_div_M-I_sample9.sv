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
    localparam CNT_WIDTH = 7;  // Needs to count up to 99 (for 1MHz)
    
    // Shared counter with Gray encoding
    reg [CNT_WIDTH-1:0] cnt;
    reg [CNT_WIDTH-1:0] cnt_gray;
    
    // Clock enable signals
    wire clk_50_en;
    wire clk_10_en;
    wire clk_1_en;
    
    // Binary to Gray conversion
    always @(*) begin
        cnt_gray = cnt ^ (cnt >> 1);
    end
    
    // Shared counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt <= 0;
        end else begin
            if (cnt == 99) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
    
    // Clock enable generation
    assign clk_50_en = 1'b1;  // Always toggle for 50MHz
    assign clk_10_en = (cnt % 10) == 0;
    assign clk_1_en = (cnt == 0);
    
    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (clk_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (clk_10_en) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (clk_1_en) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule