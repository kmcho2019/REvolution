module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div      // Divided clock output
);

parameter NUM_DIV = 4;      // Must be even and >= 2

// Validate parameter at elaboration
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

localparam SHIFT_WIDTH = NUM_DIV/2;
reg [SHIFT_WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize shift register with '1' in LSB
        shift_reg <= {1'b1, {(SHIFT_WIDTH-1){1'b0}}};
        clk_div <= 1'b0;
    end
    else begin
        // Circular shift right
        shift_reg <= {shift_reg[0], shift_reg[SHIFT_WIDTH-1:1]};
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule