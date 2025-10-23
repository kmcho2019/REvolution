module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

// Shift register with width = NUM_DIV/2
reg [NUM_DIV/2-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize with '1' in LSB and '0's elsewhere
        shift_reg <= {{(NUM_DIV/2-1){1'b0}}, 1'b1};
        clk_div <= 1'b0;
    end
    else begin
        // Circular shift right
        shift_reg <= {shift_reg[0], shift_reg[NUM_DIV/2-1:1]};
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule