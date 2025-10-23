module freq_divbyeven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output reg  clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter as specified

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;  // Initialize counter to zero on reset
        clk_div <= 1'b0;  // Initialize divided clock to zero on reset
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;  // Increment counter
    end else begin
        cnt <= 4'b0;  // Reset counter
        clk_div <= ~clk_div;  // Toggle divided clock output
    end
end

endmodule