module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Calculate required shift register length
localparam SHIFT_LEN = NUM_DIV/2;

// Parameter validation
generate
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        initial begin
            $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
            $finish;
        end
    end
endgenerate

reg [SHIFT_LEN-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {{(SHIFT_LEN-1){1'b0}}, 1'b1};  // Initialize with '1' in LSB
        clk_div <= 1'b0;
    end
    else begin
        // Check if '1' has reached the MSB
        if (shift_reg[SHIFT_LEN-1]) begin
            shift_reg <= {{(SHIFT_LEN-1){1'b0}}, 1'b1};  // Reset to initial pattern
            clk_div <= ~clk_div;  // Toggle output clock
        end
        else begin
            shift_reg <= shift_reg << 1;  // Shift left
        end
    end
end

endmodule