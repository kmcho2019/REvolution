module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;  // Stores last 3 bytes (oldest at [23:16])

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte and shift out oldest
            shift_reg <= {shift_reg[15:0], in};
            
            // Check if we have 3 bytes and oldest has in[3]=1
            done <= (&shift_reg[23:16]) ? 1'b0 :  // Prevent done when all bits are 0 after reset
                    (shift_reg[19] && (&shift_reg[23:16] !== 1'b0));  // in[3] of oldest byte
        end
    end

endmodule