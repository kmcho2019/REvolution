module freq_diveven #(
    parameter NUM_DIV = 4  // Example division factor, must be even
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'd0;
            clk_div <= ~clk_div;  // Toggle divided clock output
        end
    end
end

endmodule