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
    wire pos_toggle;
    wire neg_toggle;

    // Positive edge counter and toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= (pos_cnt == NUM_DIV-1) ? 0 : pos_cnt + 1;
        end
    end
    
    assign pos_toggle = (pos_cnt >= HALF_DIV) && rst_n;

    // Negative edge counter and toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= (neg_cnt == NUM_DIV-1) ? 0 : neg_cnt + 1;
        end
    end
    
    assign neg_toggle = (neg_cnt >= HALF_DIV) && rst_n;

    // Output generation (OR of both toggle signals)
    assign clk_div = pos_toggle | neg_toggle;

endmodule