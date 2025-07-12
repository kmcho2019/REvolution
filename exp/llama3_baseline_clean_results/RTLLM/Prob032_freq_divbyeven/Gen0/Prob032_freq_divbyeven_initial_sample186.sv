module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 10; // Example even number for division, must be an even number

reg [3:0] cnt; // 4-bit counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active-low reset
        cnt <= 4'd0; // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock output to zero
    end else if (cnt < (NUM_DIV / 2 - 1)) begin // Counter hasn't reached the limit
        cnt <= cnt + 1; // Increment counter
    end else begin // Counter has reached the limit
        cnt <= 4'd0; // Reset counter to zero
        clk_div <= ~clk_div; // Toggle divided clock output
    end
end

endmodule