module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate counter maximum values
    localparam CNT_10_MAX = (DIV_10/DIV_50)-1;
    localparam CNT_1_MAX = (DIV_1/DIV_10)-1;

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end

    // Counter for CLK_10 (divide by 10)
    wire clk_10_en;
    counter #(.MAX(CNT_10_MAX)) counter_10 (
        .clk(CLK_in),
        .rst(RST),
        .enable(clk_50_reg),  // Only count when CLK_50 is high
        .term_count(clk_10_en)
    );
    
    // CLK_10 generation
    reg clk_10_reg;
    assign CLK_10 = clk_10_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_10_reg <= 1'b0;
        else if (clk_10_en) clk_10_reg <= ~clk_10_reg;
    end

    // Counter for CLK_1 (divide by 100)
    wire clk_1_en;
    counter #(.MAX(CNT_1_MAX)) counter_100 (
        .clk(CLK_in),
        .rst(RST),
        .enable(clk_10_en),  // Only count when CLK_10 enables
        .term_count(clk_1_en)
    );
    
    // CLK_1 generation
    reg clk_1_reg;
    assign CLK_1 = clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_1_reg <= 1'b0;
        else if (clk_1_en) clk_1_reg <= ~clk_1_reg;
    end

endmodule

// Generic down-counter module with optimal width
module counter #(
    parameter MAX = 4
)(
    input wire clk,
    input wire rst,
    input wire enable,
    output wire term_count
);
    reg [$clog2(MAX+1)-1:0] count;
    
    assign term_count = (count == 0);
    
    always @(posedge clk or posedge rst) begin
        if (rst) count <= MAX;
        else if (enable) begin
            if (term_count) count <= MAX;
            else count <= count - 1'b1;
        end
    end
endmodule