module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output reg  clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Check the current count and either increment or reset and toggle
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing clk_div
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle clk_div
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule