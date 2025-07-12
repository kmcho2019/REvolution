module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor (must be an even number)
) (
    input  logic clk,      // Input clock signal
    input  logic rst_n,    // Active-low reset signal
    output logic clk_div   // Divided clock output signal
);

logic [3:0] cnt;           // 4-bit counter
logic       clk_div_int;  // Internal divided clock signal

// Counter limit (half of NUM_DIV - 1)
localparam CNT_LIMIT = (NUM_DIV / 2) - 1;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt         <= 4'b0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt < CNT_LIMIT) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1'b1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt         <= 4'b0;
            clk_div_int <= ~clk_div_int;
        end
    end
end

assign clk_div = clk_div_int;  // Assign internal divided clock signal to output

endmodule