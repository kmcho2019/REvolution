module freq_diveven #(
    parameter NUM_DIV = 10 // Even number division factor
)(
    input clk, // Input clock signal
    input rst_n, // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0; // Reset counter on active-low reset
        clk_div <= 1'b0; // Reset divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if below threshold
        end else begin
            cnt <= 4'b0; // Reset counter when threshold is reached
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule