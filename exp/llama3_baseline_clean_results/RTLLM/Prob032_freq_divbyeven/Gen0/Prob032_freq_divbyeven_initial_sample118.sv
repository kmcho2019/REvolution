module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (must be an even number)
) (
    input  wire clk,       // Input clock signal
    input  wire rst_n,     // Active-low reset signal
    output reg  clk_div    // Divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin      // Reset condition
        cnt   <= 4'd0;     // Initialize counter to zero
        clk_div <= 1'b0;  // Initialize divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'd0;    // Reset counter to zero when it reaches the limit
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule