module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor, must be an even number
) (
    input  logic clk,      // Input clock signal
    input  logic rst_n,     // Active-low reset signal
    output logic clk_div    // Divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt  <= 4'd0;  // Reset counter to zero
        clk_div <= 1'b0;  // Reset divided clock to zero
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt  <= cnt + 1;  // Increment counter
    end else begin
        cnt  <= 4'd0;  // Reset counter
        clk_div <= ~clk_div;  // Toggle divided clock output
    end
end

endmodule