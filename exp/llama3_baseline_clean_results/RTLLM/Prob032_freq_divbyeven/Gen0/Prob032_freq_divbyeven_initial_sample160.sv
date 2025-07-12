module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (even number)
) (
    input  logic clk,      // Input clock signal
    input  logic rst_n,     // Active-low reset signal
    output logic clk_div    // Divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter register

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter and divided clock signal on active-low reset
        cnt   <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter until it reaches half of NUM_DIV - 1
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock signal
            cnt   <= 4'd0;
            clk_div <= ~clk_div;  // Toggle divided clock signal
        end
    end
end

endmodule