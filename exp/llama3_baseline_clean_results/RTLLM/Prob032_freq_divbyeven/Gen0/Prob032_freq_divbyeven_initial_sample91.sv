module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
)(
    input  clk,           // Input clock signal
    input  rst_n,          // Active-low reset signal
    output reg clk_div     // Divided clock output signal
);

reg [3:0] cnt;            // 4-bit counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin     // Active-low reset: reset counter and clk_div
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;  // Increment counter if it's less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'b0;     // Reset counter when it reaches the limit
            clk_div <= ~clk_div;  // Toggle divided clock output
        end
    end
end

endmodule