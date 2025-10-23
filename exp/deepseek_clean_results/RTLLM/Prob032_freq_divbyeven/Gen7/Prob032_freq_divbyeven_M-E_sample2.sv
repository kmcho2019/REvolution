module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

localparam SHIFT_LEN = NUM_DIV / 2;
reg [SHIFT_LEN-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize with '1' in LSB
        shift_reg <= { {(SHIFT_LEN-1){1'b0}}, 1'b1 };
    end else begin
        // Circular shift right
        shift_reg <= { shift_reg[0], shift_reg[SHIFT_LEN-1:1] };
    end
end

// Output is MSB of shift register
assign clk_div = shift_reg[SHIFT_LEN-1];

endmodule