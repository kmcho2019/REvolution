module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HALF_DIV = (NUM_DIV - 1)/2;
    
    reg [CNT_WIDTH-1:0] pos_cnt;
    reg [CNT_WIDTH-1:0] neg_cnt;
    reg pos_toggle;
    reg neg_toggle;
    reg clk_div_reg;

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            pos_toggle <= 0;
        end else begin
            if (pos_cnt == NUM_DIV-1) begin
                pos_cnt <= 0;
            end else begin
                pos_cnt <= pos_cnt + 1;
            end
            
            // Toggle at half point
            if (pos_cnt == HALF_DIV) begin
                pos_toggle <= ~pos_toggle;
            end
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            neg_toggle <= 0;
        end else begin
            if (neg_cnt == NUM_DIV-1) begin
                neg_cnt <= 0;
            end else begin
                neg_cnt <= neg_cnt + 1;
            end
            
            // Toggle at wrap-around
            if (neg_cnt == NUM_DIV-1) begin
                neg_toggle <= ~neg_toggle;
            end
        end
    end

    // Output generation (XOR of both toggle signals)
    always @(*) begin
        clk_div_reg = pos_toggle ^ neg_toggle;
    end

    assign clk_div = clk_div_reg;

endmodule