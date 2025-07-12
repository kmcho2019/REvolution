module freq_diveven #(
    parameter NUM_DIV = 8  // Division factor, must be an even number
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // Counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset
        cnt <= 4'b0000;  // Reset counter to zero
        clk_div <= 1'b0;  // Reset divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;  // Increment counter
        end else begin
            cnt <= 4'b0000;  // Reset counter
            clk_div <= ~clk_div;  // Toggle divided clock output
        end
    end
end

endmodule