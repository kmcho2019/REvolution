module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] message_shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            message_shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            message_shift_reg <= {message_shift_reg[15:0], in};
            
            // Check if we have a complete valid message
            done <= (message_shift_reg[19] &&  // First byte's bit3 (position 19 in 24-bit reg)
                    (&message_shift_reg[23:16]) !== 1'bx &&  // All bits defined
                    (&message_shift_reg[15:8]) !== 1'bx &&
                    (&message_shift_reg[7:0]) !== 1'bx);
        end
    end

endmodule