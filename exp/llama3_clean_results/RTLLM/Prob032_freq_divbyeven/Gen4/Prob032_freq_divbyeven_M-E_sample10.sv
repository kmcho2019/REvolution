module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Must be an even number

reg [7:0] cnt; // Counter to track input clock cycles
reg prev_clk_div; // Previous state of clk_div for edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd0;
        clk_div <= 1'b0;
        prev_clk_div <= 1'b0;
    end else begin
        cnt <= cnt + 1;
        
        // Toggle clk_div when counter reaches NUM_DIV
        if (cnt == (NUM_DIV - 1)) begin
            clk_div <= ~clk_div;
            cnt <= 8'd0; // Reset counter
        end
        
        // Store previous state of clk_div for edge detection
        prev_clk_div <= clk_div;
    end
end

endmodule