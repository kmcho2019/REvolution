module freq_diveven #(
    parameter NUM_DIV = 4 // Example even division factor
) (
    input clk, // Input clock signal
    input rst_n, // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter to track clock cycles

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        cnt <= 4'd0; // Reset counter to zero
        clk_div <= 1'b0; // Reset clk_div to zero
    end else begin // Normal operation
        if (cnt < (NUM_DIV / 2 - 1)) begin // Counter hasn't reached the limit
            cnt <= cnt + 1; // Increment counter
            // clk_div remains unchanged
        end else begin // Counter has reached the limit
            cnt <= 4'd0; // Reset counter to zero
            clk_div <= ~clk_div; // Toggle clk_div
        end
    end
end

endmodule