module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even
reg [(NUM_DIV/2)-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {(NUM_DIV/2){1'b0}};
        clk_div <= 1'b0;
    end
    else begin
        // Rotate the shift register
        shift_reg <= {shift_reg[NUM_DIV/2-2:0], shift_reg[NUM_DIV/2-1]};
        // Output is the MSB
        clk_div <= shift_reg[NUM_DIV/2-1];
    end
end

// Initialize shift register with correct pattern
initial begin
    shift_reg = {{(NUM_DIV/4){2'b01}}};
end

endmodule