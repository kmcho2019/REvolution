module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

localparam SHIFT_LEN = NUM_DIV/2;
reg [SHIFT_LEN-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {1'b1, {(SHIFT_LEN-1){1'b0}}};
        clk_div <= 0;
    end else begin
        // Circular shift right
        shift_reg <= {shift_reg[0], shift_reg[SHIFT_LEN-1:1]};
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule