module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input  clk,          // Input clock signal
    input  rst_n,        // Active-low reset signal
    output clk_div       // Divided clock output signal
);

reg [3:0] cnt;           // 4-bit counter register
reg       clk_div;       // Divided clock output register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin    // Reset condition
        cnt   <= 4'd0;   // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt   <= cnt + 1; // Increment counter
        end else begin
            cnt   <= 4'd0;   // Reset counter
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule