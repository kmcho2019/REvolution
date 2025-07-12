module freq_diveven #(
    parameter NUM_DIV = 4  // Must be an even number
)(
    input  clk,        // Input clock signal
    input  rst_n,      // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter if it's less than half of NUM_DIV - 1
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
            clk_div <= clk_div;  // No change in divided clock output
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule