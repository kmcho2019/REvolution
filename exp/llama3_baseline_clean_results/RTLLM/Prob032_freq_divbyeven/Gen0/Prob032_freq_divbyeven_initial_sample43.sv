module freq_diveven (
    input  wire        clk,      // Input clock signal
    input  wire        rst_n,    // Active-low reset signal
    output reg          clk_div   // Divided clock output signal
);

parameter NUM_DIV = 10;  // Division factor, must be an even number

reg [3:0] cnt;  // 4-bit counter register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;  // Initialize counter to zero on reset
        clk_div <= 1'b0;  // Initialize divided clock output to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;  // Increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'd0;  // Reset counter when limit is reached
            clk_div <= ~clk_div;  // Toggle divided clock output when counter resets
        end
    end
end

endmodule