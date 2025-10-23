module freq_diveven #(
    parameter NUM_DIV = 4  // Must be an even number
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active-low reset
        cnt <= 4'b0; // Reset counter
        clk_div <= 1'b0; // Reset divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // Increment counter until limit
            cnt <= cnt + 1'b1; // Increment counter
        end else begin
            cnt <= 4'b0; // Reset counter
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule