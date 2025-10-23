module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

localparam SHIFT_LEN = NUM_DIV/2;
reg [SHIFT_LEN-1:0] shift_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        // Initialize shift register with 1 in LSB
        shift_reg <= { {SHIFT_LEN-1{1'b0}}, 1'b1 };
        clk_div <= 1'b0;
    end
    else begin
        // Circular shift right
        shift_reg <= { shift_reg[0], shift_reg[SHIFT_LEN-1:1] };
        
        // Toggle when '1' wraps around to MSB
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule