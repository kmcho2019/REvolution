module freq_diveven #(
    parameter NUM_DIV = 4 // Even number division factor
) (
    input clk,  // Input clock signal
    input rst_n, // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'b0; // Reset counter to zero
        clk_div <= 1'b0; // Reset divided clock signal to zero
    end else begin
        if (cnt < (NUM_DIV - 1) / 2) begin // Counter is less than half of NUM_DIV - 1
            cnt <= cnt + 1; // Increment counter without changing clk_div
        end else begin
            cnt <= 4'b0; // Reset counter to zero
            clk_div <= ~clk_div; // Toggle divided clock signal
        end
    end
end

endmodule