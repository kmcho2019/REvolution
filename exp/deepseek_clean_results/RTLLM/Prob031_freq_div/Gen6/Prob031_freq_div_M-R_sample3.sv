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
    
    // Counter widths
    localparam CNT_10_WIDTH = $clog2(DIV_10);
    localparam CNT_1_WIDTH = $clog2(DIV_1);

    // Registers for counters and clocks
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_100;
    reg clk_50_reg;
    reg clk_10_reg;
    reg clk_1_reg;

    // Terminal count signals
    wire cnt_10_term = (cnt_10 == DIV_10-1);
    wire cnt_100_term = (cnt_100 == DIV_1-1);

    // Clock assignments
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = clk_10_reg;
    assign CLK_1 = clk_1_reg;

    // Single always block for all sequential logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all counters and clocks
            clk_50_reg <= 1'b0;
            clk_10_reg <= 1'b0;
            clk_1_reg <= 1'b0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50 generation (divide by 2)
            clk_50_reg <= ~clk_50_reg;
            
            // CLK_10 generation (divide by 10)
            if (cnt_10_term) begin
                cnt_10 <= 0;
                clk_10_reg <= ~clk_10_reg;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
            
            // CLK_1 generation (divide by 100)
            if (cnt_100_term) begin
                cnt_100 <= 0;
                clk_1_reg <= ~clk_1_reg;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule