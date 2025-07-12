module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active-low synchronous reset
    output reg clk_div       // Registered divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;       // Default division by 4

// Calculate shift register width (half the division factor)
localparam SHIFT_WIDTH = NUM_DIV >> 1;

reg [SHIFT_WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize with '1' in LSB (others '0')
        shift_reg <= { {(SHIFT_WIDTH-1){1'b0}}, 1'b1 };
        clk_div <= 1'b0;
    end
    else begin
        // Rotate the shift register right
        shift_reg <= {shift_reg[0], shift_reg[SHIFT_WIDTH-1:1]};
        
        // Toggle output when '1' wraps around from position 0
        if (shift_reg[0]) begin
            clk_div <= ~clk_div;
        end
    end
end

// Static parameter checking (for simulation)
`ifdef SIMULATION
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("Error: NUM_DIV must be even and >= 2. Got %0d", NUM_DIV);
        $finish;
    end
end
`endif

endmodule