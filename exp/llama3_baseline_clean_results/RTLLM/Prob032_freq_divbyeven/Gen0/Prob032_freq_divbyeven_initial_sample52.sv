module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input  clk,           // Input clock signal
    input  rst_n,         // Active-low reset signal
    output reg clk_div    // Divided clock output signal
);

reg [3:0] cnt;            // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;      // Reset counter on low reset signal
        clk_div <= 1'b0;  // Reset output clock on low reset signal
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;  // Increment counter
        end else begin
            cnt <= 4'd0;      // Reset counter
            clk_div <= ~clk_div;  // Toggle output clock
        end
    end
end

endmodule