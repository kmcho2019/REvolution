module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Division factor (even number)

reg [3:0] cnt; // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0; // Initialize counter to zero on reset
        clk_div <= 1'b0; // Initialize divided clock signal to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'd0; // Reset counter to zero when limit is reached
            clk_div <= ~clk_div; // Toggle divided clock signal when limit is reached
        end
    end
end

endmodule