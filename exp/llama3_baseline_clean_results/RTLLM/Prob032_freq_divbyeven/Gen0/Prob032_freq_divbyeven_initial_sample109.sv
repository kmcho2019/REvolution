module freq_diveven #(
    parameter NUM_DIV = 10  // Example division factor, must be an even number
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        cnt <= 4'd0;  // Initialize counter to zero
        clk_div <= 1'b0;  // Initialize divided clock signal to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter if it's less than half of NUM_DIV - 1
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock signal when limit is reached
            cnt <= 4'd0;
            clk_div <= ~clk_div;  // Toggle divided clock output
        end
    end
end

endmodule