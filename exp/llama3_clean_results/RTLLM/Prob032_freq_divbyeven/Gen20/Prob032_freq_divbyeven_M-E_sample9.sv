// Frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

// Calculate the required shift register width based on NUM_DIV
localparam SHIFT_REG_WIDTH = $clog2(NUM_DIV);

reg [SHIFT_REG_WIDTH-1:0] shift_reg;  // Shift register
reg [SHIFT_REG_WIDTH-1:0] cnt;        // Counter

// Sequential logic for shift register and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= '0;
        cnt <= '0;
        clk_div <= '0;
    end else begin
        // Shift the shift register to the left and insert '1' at the rightmost bit
        shift_reg <= {shift_reg[SHIFT_REG_WIDTH-2:0], 1'b1};
        
        // Increment the counter
        cnt <= cnt + 1;
        
        // If the counter reaches half of NUM_DIV, reset it and toggle clk_div
        if (cnt == (NUM_DIV / 2)) begin
            cnt <= '0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule