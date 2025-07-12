module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output reg         clk_div // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter to track clock cycles

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock signal on active-low reset
        cnt    <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            // Increment counter until it reaches half of NUM_DIV - 1
            cnt <= cnt + 1'b1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt    <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule