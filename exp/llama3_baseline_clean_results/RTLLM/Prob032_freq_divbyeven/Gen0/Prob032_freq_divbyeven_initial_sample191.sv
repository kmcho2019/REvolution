module freq_diveven(
    input        clk,
    input        rst_n,
    output reg   clk_div
);

parameter NUM_DIV = 8; // Example division factor, must be an even number

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0; // Reset counter to 0 on reset
        clk_div <= 1'b0; // Reset divided clock output to 0
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if not at the limit
        end else begin
            cnt <= 4'd0; // Reset counter to 0 when it reaches the limit
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule