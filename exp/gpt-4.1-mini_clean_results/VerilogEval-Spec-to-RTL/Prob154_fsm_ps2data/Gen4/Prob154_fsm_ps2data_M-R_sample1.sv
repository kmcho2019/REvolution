module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot state encoding
    reg state_wait_sync, state_byte2, state_byte3;
    reg next_wait_sync, next_byte2, next_byte3;

    // Shift register to hold 3 bytes (24 bits)
    reg [23:0] msg_shift;

    // Next state combinational logic
    always @(*) begin
        // Default next states to 0
        next_wait_sync = 1'b0;
        next_byte2    = 1'b0;
        next_byte3    = 1'b0;

        // State transitions
        if (state_wait_sync) begin
            if (in[3])
                next_byte2 = 1'b1;
            else
                next_wait_sync = 1'b1;
        end else if (state_byte2) begin
            next_byte3 = 1'b1;
        end else if (state_byte3) begin
            next_wait_sync = 1'b1;
        end else begin
            // Should never happen, default to wait_sync
            next_wait_sync = 1'b1;
        end
    end

    // Synchronous state and output update
    always @(posedge clk) begin
        if (reset) begin
            state_wait_sync <= 1'b1;
            state_byte2     <= 1'b0;
            state_byte3     <= 1'b0;
            msg_shift       <= 24'd0;
            out_bytes       <= 24'd0;
            done            <= 1'b0;
        end else begin
            // Update state registers
            state_wait_sync <= next_wait_sync;
            state_byte2     <= next_byte2;
            state_byte3     <= next_byte3;

            done <= 1'b0;  // Default done low unless asserted below

            if (state_wait_sync) begin
                // Only capture first byte if in[3] set
                if (in[3]) begin
                    // Load first byte into highest byte of shift reg
                    msg_shift <= {in, 16'd0};
                end
                // else msg_shift unchanged (don't care)
            end else if (state_byte2) begin
                // Shift existing bytes left by 8 bits, input new byte as LSB byte
                msg_shift <= {msg_shift[15:0], in};
            end else if (state_byte3) begin
                msg_shift <= {msg_shift[15:0], in};
                done <= 1'b1;          // Assert done one cycle after 3rd byte
                out_bytes <= {msg_shift[23:16], msg_shift[15:8], in};  // byte1, byte2, byte3
            end
        end
    end

endmodule