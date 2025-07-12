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

    // Calculate optimal counter widths
    localparam CNT_WIDTH = $clog2(DIV_1);

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end
    assign CLK_50 = clk_50_reg;

    // Combined counter for 10MHz and 1MHz generation
    reg [CNT_WIDTH-1:0] counter;
    reg clk_10_reg, clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= DIV_1 - 1;
            clk_10_reg <= 1'b0;
            clk_1_reg <= 1'b0;
        end
        else begin
            if (counter == 0) begin
                counter <= DIV_1 - 1;
            end
            else begin
                counter <= counter - 1;
            end
            
            // Toggle 10MHz every DIV_10/2 counts
            if (counter % (DIV_10/2) == 0) begin
                clk_10_reg <= ~clk_10_reg;
            end
            
            // Toggle 1MHz every DIV_1/2 counts
            if (counter == (DIV_1/2 - 1)) begin
                clk_1_reg <= ~clk_1_reg;
            end
        end
    end
    
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

endmodule