module freq_diveven #
(
    parameter NUM_DIV = 4  // Even number to divide the clock frequency
)
(
    input   clk,           // Input clock signal
    input   rst_n,          // Active-low reset signal
    output  clk_div         // Divided clock output signal
);

reg [3:0] cnt;              // 4-bit counter register
reg       clk_div;          // Divided clock output signal

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt     <= 4'd0;    // Initialize counter to zero
        clk_div <= 1'b0;    // Initialize divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt     <= cnt + 1;  // Increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt     <= 4'd0;    // Reset counter to zero
            clk_div <= ~clk_div; // Toggle divided clock output signal
        end
    end
end

endmodule