module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor, must be an even number
) (
    input  wire clk,        // Input clock signal
    input  wire rst_n,      // Active-low reset signal
    output wire clk_div     // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter register
wire       cnt_limit;  // Counter limit based on NUM_DIV

assign cnt_limit = (NUM_DIV / 2) - 1;  // Calculate the counter limit

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset condition
        cnt <= 4'd0;   // Reset counter to zero
        clk_div <= 1'b0;  // Reset divided clock output to zero
    end else if (cnt < cnt_limit) begin
        cnt <= cnt + 1'b1;  // Increment counter if less than limit
    end else begin
        cnt <= 4'd0;   // Reset counter to zero when reaches limit
        clk_div <= ~clk_div;  // Toggle divided clock output
    end
end

endmodule