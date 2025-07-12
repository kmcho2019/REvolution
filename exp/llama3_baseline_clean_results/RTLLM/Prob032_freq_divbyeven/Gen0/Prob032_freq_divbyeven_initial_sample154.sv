module freq_diveven #(
    parameter NUM_DIV = 8 // Must be an even number
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'd0; // Reset counter
        clk_div <= 1'b0; // Reset divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // Increment counter until half of (NUM_DIV - 1)
            cnt <= cnt + 1;
        end else begin // Toggle output and reset counter when limit is reached
            cnt <= 4'd0;
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule