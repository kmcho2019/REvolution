module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Division factor, must be an even number
reg [3:0] cnt; // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active-low reset
        cnt <= 4'd0; // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if it hasn't reached the halfway point
        end else if (cnt == (NUM_DIV / 2 - 1)) begin
            cnt <= 4'd0; // Reset counter to zero when it reaches the halfway point
            clk_div <= ~clk_div; // Toggle divided clock output
        end else begin
            cnt <= cnt + 1; // Continue incrementing the counter beyond the halfway point
        end
    end
end

endmodule