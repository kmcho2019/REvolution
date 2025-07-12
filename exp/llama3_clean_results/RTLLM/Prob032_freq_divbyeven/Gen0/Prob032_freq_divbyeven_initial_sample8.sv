module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Example division factor, must be an even number

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'd0; // Reset counter to zero
        clk_div <= 1'b0; // Reset divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1; // Increment counter
        end else begin
            cnt <= 4'd0; // Reset counter
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule