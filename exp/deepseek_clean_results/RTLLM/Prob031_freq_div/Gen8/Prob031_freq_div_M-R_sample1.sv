module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Derived parameters
    localparam CNT_10_MAX = (DIV_10/2)-1;
    localparam CNT_1_MAX = (DIV_1/2)-1;
    
    // Combined counter for both 10MHz and 1MHz
    reg [6:0] cnt_gray;
    wire [6:0] cnt_bin;
    
    // Clock registers
    reg clk_50_reg;
    reg clk_10_reg;
    reg clk_1_reg;
    
    // Binary to Gray conversion
    assign cnt_bin = {1'b0, cnt_gray[6:1]} ^ cnt_gray;
    
    // Output assignments
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;
    
    // 50MHz clock generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
        end else begin
            clk_50_reg <= ~clk_50_reg;
        end
    end
    
    // Combined counter for 10MHz and 1MHz clocks
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_gray <= 7'b0;
            clk_10_reg <= 1'b0;
            clk_1_reg <= 1'b0;
        end else begin
            // Gray counter increment
            cnt_gray <= cnt_gray + 1'b1;
            
            // 10MHz clock toggle
            if (cnt_bin[2:0] == CNT_10_MAX) begin
                clk_10_reg <= ~clk_10_reg;
            end
            
            // 1MHz clock toggle
            if (cnt_bin == CNT_1_MAX) begin
                clk_1_reg <= ~clk_1_reg;
                cnt_gray <= 7'b0; // Reset counter at 1MHz boundary
            end
        end
    end

endmodule