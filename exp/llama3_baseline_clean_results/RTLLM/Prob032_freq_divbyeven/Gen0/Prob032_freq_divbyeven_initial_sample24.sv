module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Default division factor, must be an even number

reg [3:0] cnt; // 4-bit counter to track clock cycles

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'd0; // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin // Increment counter until halfway point
            cnt <= cnt + 1;
        end else begin // Reset counter and toggle divided clock
            cnt <= 4'd0;
            clk_div <= ~clk_div; // Toggle divided clock
        end
    end
end

endmodule