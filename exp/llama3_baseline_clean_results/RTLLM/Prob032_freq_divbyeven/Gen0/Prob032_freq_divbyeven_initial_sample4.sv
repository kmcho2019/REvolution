// freq_diveven module

module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (even number)
) (
    input  clk,           // Input clock signal
    input  rst_n,          // Active-low reset signal
    output reg clk_div     // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter

// Check if NUM_DIV is an even number during compilation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV (%0d) must be an even number.", NUM_DIV);
    end else begin
        $info("NUM_DIV is set to %0d.", NUM_DIV);
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Active-low reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'd0;
            clk_div <= ~clk_div;  // Toggle clk_div
        end
    end
end

endmodule