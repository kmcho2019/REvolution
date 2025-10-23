module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

localparam SHIFT_WIDTH = NUM_DIV/2;
reg [SHIFT_WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize shift register with 1 in LSB
        shift_reg <= { {SHIFT_WIDTH-1{1'b0}}, 1'b1 };
        clk_div <= 1'b0;
    end
    else begin
        // Rotate the shift register right
        shift_reg <= { shift_reg[0], shift_reg[SHIFT_WIDTH-1:1] };
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule