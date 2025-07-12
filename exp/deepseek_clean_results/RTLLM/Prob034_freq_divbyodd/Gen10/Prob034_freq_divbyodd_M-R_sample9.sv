module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Calculate half cycle point (integer division)
    localparam HALF_CYCLE = (NUM_DIV - 1)/2;
    
    reg [31:0] edge_count;
    reg clk_div1, clk_div2;
    
    // Main counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_count <= 0;
            clk_div1 <= 0;
            clk_div2 <= 0;
        end else begin
            // Increment counter on both edges (simulated)
            edge_count <= (edge_count == NUM_DIV - 1) ? 0 : edge_count + 1;
            
            // Generate clk_div1 (rising edge aligned)
            if (edge_count == 0) clk_div1 <= 1;
            else if (edge_count == HALF_CYCLE) clk_div1 <= 0;
            
            // Generate clk_div2 (falling edge aligned)
            if (edge_count == HALF_CYCLE) clk_div2 <= 1;
            else if (edge_count == 0) clk_div2 <= 0;
        end
    end
    
    // Combine both clocks to create final output
    assign clk_div = clk_div1 | clk_div2;

endmodule