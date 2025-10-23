module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Combined shift register and state tracking
    reg [9:0] shift_reg;  // [0:start, 1:LSB...8:MSB, 9:stop]
    reg active;           // Single-bit state (0=IDLE, 1=ACTIVE)
    wire valid_stop = shift_reg[9];
    wire valid_start = ~shift_reg[0];
    wire byte_complete = &shift_reg[8:1];  // All data bits received

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b1111111111;  // Idle state (all 1's)
            active <= 1'b0;
        end else begin
            if (active) begin
                // Shift in new bit (LSB first)
                shift_reg <= {in, shift_reg[9:1]};
                
                // Check for completion or error
                if (shift_reg[9] && valid_start) begin
                    active <= 1'b0;  // Valid stop bit, return to IDLE
                end else if (byte_complete && !shift_reg[9]) begin
                    // Missing stop bit - stay active until we see stop
                end
            end else begin
                // IDLE state - wait for start bit
                if (~in) begin
                    active <= 1'b1;
                    shift_reg <= {9'b111111111, in};  // Initialize with start bit
                end
            end
        end
    end

    // Done pulses when valid byte is complete
    assign done = active && byte_complete && valid_stop && valid_start;

endmodule