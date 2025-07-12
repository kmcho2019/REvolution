module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Must be even number (2, 4, 6, ...)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number");
    end
end

// Shift register with circulating '1'
localparam SR_LEN = NUM_DIV/2;
reg [SR_LEN-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize with '1' at LSB
        shift_reg <= {{(SR_LEN-1){1'b0}}, 1'b1};
        clk_div <= 1'b0;
    end else begin
        // Circular shift right
        shift_reg <= {shift_reg[0], shift_reg[SR_LEN-1:1]};
        
        // Toggle output when '1' wraps around
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule