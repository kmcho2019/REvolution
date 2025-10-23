module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2

// Parameter validation
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number >= 2");
        $finish;
    end
end

localparam SHIFT_LEN = NUM_DIV/2;
reg [SHIFT_LEN-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {1'b1, {(SHIFT_LEN-1){1'b0}}}; // Initialize with single '1'
        clk_div <= 1'b0;
    end
    else begin
        // Circular shift right
        shift_reg <= {shift_reg[0], shift_reg[SHIFT_LEN-1:1]};
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule