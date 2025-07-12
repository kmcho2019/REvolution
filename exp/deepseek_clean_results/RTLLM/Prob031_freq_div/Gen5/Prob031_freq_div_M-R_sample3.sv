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

    // Counter registers
    reg [CNT_10_WIDTH-1:0] cnt_10;
    reg [CNT_1_WIDTH-1:0] cnt_100;
    reg clk_50_reg;

    // Clock enables
    wire clk_50_en = 1'b1; // Always toggle
    wire clk_10_en = (cnt_10 == DIV_10-1);
    wire clk_1_en = (cnt_100 == DIV_1-1);

    // Single always block for all counters
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk_50_reg <= 1'b0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50 counter (divide by 2)
            clk_50_reg <= ~clk_50_reg;
            
            // CLK_10 counter (divide by 10)
            if (clk_10_en) begin
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
            
            // CLK_1 counter (divide by 100)
            if (clk_1_en) begin
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

    // Continuous assignments for clock outputs
    assign CLK_50 = clk_50_reg;
    assign CLK_10 = cnt_10 < (DIV_10/2);
    assign CLK_1 = cnt_100 < (DIV_1/2);

endmodule