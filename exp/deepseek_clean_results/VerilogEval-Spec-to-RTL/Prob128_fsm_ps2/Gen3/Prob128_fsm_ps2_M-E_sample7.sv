module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;  // Stores last 3 bytes

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Check if oldest byte has bit3 set (message start)
            done <= (shift_reg[19] && (&shift_reg[23:16]));
            
            // Clear register when we output done
            if (done) begin
                shift_reg <= 24'b0;
            end
        end
    end

endmodule