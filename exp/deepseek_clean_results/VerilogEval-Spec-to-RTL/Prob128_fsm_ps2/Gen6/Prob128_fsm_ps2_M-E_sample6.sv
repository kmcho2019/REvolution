module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;
    wire message_complete = shift_reg[23+3];  // Check in[3] of first byte in window

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Check for complete message
            done <= (shift_reg[23+3] && (&shift_reg[23:16])) ? 1'b1 : 1'b0;
            
            // Clear register after message is complete
            if (done) begin
                shift_reg <= 24'b0;
            end
        end
    end

endmodule