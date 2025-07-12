module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // CLK_50 generation (divide by 2) - simplest case remains unchanged
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // CLK_10 generation (divide by 10) - Gray code counter
    reg [2:0] cnt_10_gray;
    reg clk_10_reg;
    wire [2:0] next_cnt_10_gray = (cnt_10_gray == 3'b100) ? 3'b000 : 
                                 (cnt_10_gray == 3'b000) ? 3'b001 :
                                 (cnt_10_gray == 3'b001) ? 3'b011 :
                                 (cnt_10_gray == 3'b011) ? 3'b010 : 3'b100;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10_gray <= 3'b000;
            clk_10_reg <= 1'b0;
        end
        else begin
            cnt_10_gray <= next_cnt_10_gray;
            if (cnt_10_gray == 3'b100) begin
                clk_10_reg <= ~clk_10_reg;
            end
        end
    end
    assign CLK_10 = clk_10_reg;

    // CLK_1 generation (divide by 100) - Cascaded 10×10 with Gray code
    reg [2:0] cnt_100_1, cnt_100_2;
    reg clk_1_reg;
    wire [2:0] next_cnt_100_1 = (cnt_100_1 == 3'b100) ? 3'b000 : 
                               (cnt_100_1 == 3'b000) ? 3'b001 :
                               (cnt_100_1 == 3'b001) ? 3'b011 :
                               (cnt_100_1 == 3'b011) ? 3'b010 : 3'b100;
    
    wire cnt_100_1_tc = (cnt_100_1 == 3'b100);
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100_1 <= 3'b000;
            cnt_100_2 <= 3'b000;
            clk_1_reg <= 1'b0;
        end
        else begin
            cnt_100_1 <= next_cnt_100_1;
            
            if (cnt_100_1_tc) begin
                cnt_100_2 <= (cnt_100_2 == 3'b100) ? 3'b000 : next_cnt_100_1;
                if (cnt_100_2 == 3'b100) begin
                    clk_1_reg <= ~clk_1_reg;
                end
            end
        end
    end
    assign CLK_1 = clk_1_reg;

    // Clock gating for power optimization
    // (Implementation depends on target technology's clock gating cells)
    // Typically would instantiate technology-specific clock gating cells here

endmodule