module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

// Calculate required counter width and half period
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_DIV = (NUM_DIV - 1) / 2;

reg [CNT_WIDTH-1:0] cnt_pos, cnt_neg;
reg clk_div_pos, clk_div_neg;

// Positive edge counter and divider
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_div_pos <= 0;
    end else begin
        cnt_pos <= (cnt_pos == NUM_DIV - 1) ? 0 : cnt_pos + 1;
        
        // Toggle at half point
        if (cnt_pos == HALF_DIV)
            clk_div_pos <= ~clk_div_pos;
    end
end

// Negative edge counter and divider
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_div_neg <= 0;
    end else begin
        cnt_neg <= (cnt_neg == NUM_DIV - 1) ? 0 : cnt_neg + 1;
        
        // Toggle at half point
        if (cnt_neg == HALF_DIV)
            clk_div_neg <= ~clk_div_neg;
    end
end

// Combine both edge dividers
assign clk_div = clk_div_pos | clk_div_neg;

endmodule