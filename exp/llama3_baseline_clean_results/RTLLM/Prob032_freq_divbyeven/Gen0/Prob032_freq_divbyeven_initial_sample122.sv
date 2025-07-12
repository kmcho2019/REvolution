module freq_diveven #(
    parameter NUM_DIV = 4  // Even number for division factor
) (
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output reg          clk_div // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter for clock cycle tracking

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt <= 4'd0;  // Reset counter to zero
        clk_div <= 1'b0;  // Reset divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Counter increment condition
            cnt <= cnt + 1'b1;  // Increment counter
        end else begin
            cnt <= 4'd0;  // Reset counter
            clk_div <= ~clk_div;  // Toggle divided clock output
        end
    end
end

endmodule