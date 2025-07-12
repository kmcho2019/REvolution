module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // Combined shift register for data and protocol state
    reg [10:0] shift_reg;  // Holds start + 8 data + stop bits
    reg done_reg;

    // Protocol pattern matching
    wire is_idle    = &shift_reg;          // All 1's
    wire is_receiving = ~shift_reg[9] && (^shift_reg[8:1]);  // Start bit 0 and some data bits
    wire is_stop    = shift_reg[0];       // Stop bit is 1
    wire is_error   = ~shift_reg[0] && (&shift_reg[9:1]);  // Full byte but stop=0

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 11'h7FF;  // Initialize to all 1's (idle)
            done_reg <= 1'b0;
        end else begin
            // Shift in new bit (MSB first in register)
            shift_reg <= {shift_reg[9:0], in};

            // Done logic - assert when valid stop bit is detected
            if (shift_reg[9] && ~shift_reg[10] && in) begin
                done_reg <= 1'b1;
            end else if (is_idle) begin
                done_reg <= 1'b0;
            end
        end
    end

    // Protocol error recovery - automatically resets when line goes idle
    wire protocol_error = is_error;
    assign done = done_reg && ~protocol_error;

endmodule