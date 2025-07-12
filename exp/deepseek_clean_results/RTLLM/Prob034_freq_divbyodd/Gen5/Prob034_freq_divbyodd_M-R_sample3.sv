module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    
    reg [CNT_WIDTH-1:0] cnt_pos, cnt_neg;
    reg clk_div_pos, clk_div_neg;
    
    // Positive edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div_pos <= 0;
        end
        else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
            end
            else begin
                cnt_pos <= cnt_pos + 1;
            end
            
            if (cnt_pos == TOGGLE_POINT) begin
                clk_div_pos <= ~clk_div_pos;
            end
        end
    end
    
    // Negative edge counter and clock generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div_neg <= 0;
        end
        else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
            end
            else begin
                cnt_neg <= cnt_neg + 1;
            end
            
            if (cnt_neg == TOGGLE_POINT) begin
                clk_div_neg <= ~clk_div_neg;
            end
        end
    end
    
    // Combine both edge-divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule