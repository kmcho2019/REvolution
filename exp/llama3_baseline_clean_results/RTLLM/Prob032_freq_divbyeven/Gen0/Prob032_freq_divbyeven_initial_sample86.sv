module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (must be an even number)
) (
    input  logic clk,      // Input clock signal
    input  logic rst_n,     // Active-low reset signal
    output logic clk_div    // Divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter
logic       clk_div_int;  // Internal divided clock signal

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt         <= 4'd0;  // Initialize counter to zero
        clk_div_int <= 1'b0;  // Initialize divided clock signal to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Counter less than half of (NUM_DIV - 1)
            cnt         <= cnt + 1'b1;  // Increment counter
            clk_div_int <= clk_div_int;  // No change in divided clock signal
        end else begin
            cnt         <= 4'd0;  // Reset counter to zero
            clk_div_int <= ~clk_div_int;  // Toggle divided clock signal
        end
    end
end

assign clk_div = clk_div_int;  // Continuous assignment of divided clock signal

endmodule