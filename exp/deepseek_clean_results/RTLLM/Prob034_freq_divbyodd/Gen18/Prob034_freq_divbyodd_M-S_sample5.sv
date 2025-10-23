module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial if (NUM_DIV % 2 == 0) begin
    $error("NUM_DIV must be odd");
    $finish;
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;
reg [31:0] edge_cnt;
reg clk_pos, clk_neg;

// Count both clock edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        edge_cnt <= 0;
        clk_pos <= 0;
        clk_neg <= 0;
    end else begin
        edge_cnt <= (edge_cnt == NUM_DIV - 1) ? 0 : edge_cnt + 1;
        
        // Generate phase-shifted clocks
        if (edge_cnt == HALF_DIV) clk_pos <= ~clk_pos;
        if (edge_cnt == 0) clk_neg <= ~clk_neg;
    end
end

// Combine phase-shifted clocks
assign clk_div = clk_pos ^ clk_neg;

endmodule