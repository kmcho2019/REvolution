module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 10;  // Specify the even division factor

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;  // Initialize counter to zero on reset
        clk_div <= 1'b0;  // Initialize divided clock to zero
    end
    else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;  // Increment counter
    end
    else begin
        cnt <= 4'd0;  // Reset counter to zero
        clk_div <= ~clk_div;  // Toggle divided clock output
    end
end

endmodule