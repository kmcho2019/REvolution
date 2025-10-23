module freq_diveven #(
    parameter NUM_DIV = 4 // Division factor (must be an even number)
) (
    input  logic clk,    // Input clock signal
    input  logic rst_n,  // Active-low reset signal
    output logic clk_div  // Divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;      // Reset counter to zero on reset
        clk_div <= 1'b0;  // Reset clk_div to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1'b1;  // Increment counter if not at half of NUM_DIV - 1
        end else if (cnt == (NUM_DIV / 2 - 1)) begin
            cnt <= 4'd0;      // Reset counter when it reaches half of NUM_DIV - 1
            clk_div <= ~clk_div;  // Toggle clk_div at every half of NUM_DIV clock cycles
        end
    end
end

endmodule