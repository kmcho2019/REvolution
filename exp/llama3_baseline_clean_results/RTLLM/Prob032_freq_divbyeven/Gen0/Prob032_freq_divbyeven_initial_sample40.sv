module freq_diveven (
    input clk,       // Input clock signal
    input rst_n,     // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

parameter NUM_DIV = 4;  // Division factor, must be an even number

reg [3:0] cnt;         // 4-bit counter register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;       // Initialize counter to zero on reset
        clk_div <= 1'b0;   // Initialize divided clock signal to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter
        end else begin
            cnt <= 4'd0;       // Reset counter to zero
            clk_div <= ~clk_div; // Toggle divided clock signal
        end
    end
end

endmodule