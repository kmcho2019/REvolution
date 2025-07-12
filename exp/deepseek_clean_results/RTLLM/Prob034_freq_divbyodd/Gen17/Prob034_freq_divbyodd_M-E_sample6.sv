module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
localparam FULL_CYCLE = NUM_DIV - 1;
reg [31:0] edge_counter;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        edge_counter <= 0;
        clk_div <= 0;
    end else begin
        // Count both edges
        edge_counter <= edge_counter + 1;
        
        // Toggle points for 50% duty cycle
        if (edge_counter == HALF_CYCLE || edge_counter == FULL_CYCLE) begin
            clk_div <= ~clk_div;
        end
        
        // Reset counter after full cycle
        if (edge_counter == FULL_CYCLE) begin
            edge_counter <= 0;
        end
    end
end

endmodule