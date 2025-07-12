module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Counter widths
    localparam CNT_10_WIDTH = 3;  // counts 0-4 (5 cycles)
    localparam CNT_1_WIDTH = 6;   // counts 0-49 (50 cycles)

    // CLK_50 generation (divide by 2)
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) clk_50_reg <= 1'b0;
        else clk_50_reg <= ~clk_50_reg;
    end

    // CLK_10 generation (divide by 10)
    reg [CNT_10_WIDTH-1:0] cnt10;
    reg clk_10_reg;
    wire cnt10_term = (cnt10 == 4);
    
    assign CLK_10 = clk_10_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt10 <= 0;
            clk_10_reg <= 1'b0;
        end else begin
            if (cnt10_term) begin
                cnt10 <= 0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt10 <= cnt10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    reg [CNT_1_WIDTH-1:0] cnt100;
    reg clk_1_reg;
    wire cnt100_term = (cnt100 == 49);
    
    assign CLK_1 = clk_1_reg;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt100 <= 0;
            clk_1_reg <= 1'b0;
        end else begin
            if (cnt100_term) begin
                cnt100 <= 0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt100 <= cnt100 + 1'b1;
            end
        end
    end

endmodule