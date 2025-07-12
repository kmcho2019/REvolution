module freq_diveven #(
    parameter NUM_DIV = 8  // Even number division factor, default is 8
)(
    input  clk,          // Input clock signal
    input  rst_n,        // Active-low reset signal
    output reg clk_div   // Divided clock output signal
);

reg [3:0] cnt;           // 4-bit counter register

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin    // Active-low reset
        cnt   <= 4'd0;   // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1; // Increment counter if it hasn't reached the limit
        end else begin
            cnt <= 4'd0;   // Reset counter when it reaches the limit
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule