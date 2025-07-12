module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

reg [CNT_WIDTH-1:0] pos_cnt;
reg [CNT_WIDTH-1:0] neg_cnt;
reg clk_div1;
reg clk_div2;

// Positive edge counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        clk_div1 <= 0;
    end else begin
        if (pos_cnt == NUM_DIV - 1) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= pos_cnt + 1;
        end
        
        if (pos_cnt == HALF_CYCLE) begin
            clk_div1 <= ~clk_div1;
        end
    end
end

// Negative edge counter
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
        clk_div2 <= 0;
    end else begin
        if (neg_cnt == NUM_DIV - 1) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= neg_cnt + 1;
        end
        
        if (neg_cnt == HALF_CYCLE) begin
            clk_div2 <= ~clk_div2;
        end
    end
end

// Combine both edge contributions
assign clk_div = clk_div1 | clk_div2;

endmodule