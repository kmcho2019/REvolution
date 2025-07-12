module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] pos_cnt, neg_cnt;
    wire pos_wrap, neg_wrap;
    wire pos_toggle, neg_toggle;
    
    localparam HALF_CYCLE = (NUM_DIV - 1) / 2;

    // Counter wrap conditions
    assign pos_wrap = (pos_cnt == NUM_DIV - 1);
    assign neg_wrap = (neg_cnt == NUM_DIV - 1);
    
    // Toggle conditions
    assign pos_toggle = (pos_cnt == HALF_CYCLE);
    assign neg_toggle = (neg_cnt == HALF_CYCLE);

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= pos_wrap ? 0 : pos_cnt + 1;
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= neg_wrap ? 0 : neg_cnt + 1;
        end
    end

    // Clock generation using continuous assignment
    wire pos_clk = (!rst_n) ? 1'b0 : 
                  (pos_cnt >= HALF_CYCLE) && !pos_wrap;
    
    wire neg_clk = (!rst_n) ? 1'b0 : 
                  (neg_cnt >= HALF_CYCLE) && !neg_wrap;

    // Combined output
    assign clk_div = pos_clk | neg_clk;

endmodule