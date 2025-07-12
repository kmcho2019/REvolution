module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor, must be an even number
) (
    input  clk,            // Input clock signal
    input  rst_n,          // Active-low reset signal
    output clk_div         // Divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter
reg       clk_div_int;     // Internal divided clock signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin      // Reset condition
        cnt         <= 4'd0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Counter increments without changing clk_div
            cnt <= cnt + 1;
        end else begin                      // Counter resets and clk_div toggles
            cnt         <= 4'd0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

assign clk_div = clk_div_int;  // Continuous assignment for output

endmodule