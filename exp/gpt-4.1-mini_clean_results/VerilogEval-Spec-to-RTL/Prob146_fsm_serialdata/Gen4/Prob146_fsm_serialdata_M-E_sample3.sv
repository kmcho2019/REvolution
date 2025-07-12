module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // One-hot state encoding
    localparam IDLE          = 4'b0001;
    localparam RECEIVE_BITS  = 4'b0010;
    localparam VERIFY_STOP   = 4'b0100;
    localparam ERROR_RECOVERY= 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] shift_reg, next_shift_reg;
    reg [2:0] bit_count, next_bit_count;
    reg done_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            shift_reg <= next_shift_reg;
            done <= done_next;
            if (done_next)
                out_byte <= next_shift_reg;
        end
    end

    always @(*) begin
        // Defaults
        next_state = state;
        next_bit_count = bit_count;
        next_shift_reg = shift_reg;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start bit = 0
                if (in == 1'b0) begin
                    // Start bit detected, clear shift reg and start counting bits
                    next_state = RECEIVE_BITS;
                    next_bit_count = 3'd0;
                    next_shift_reg = 8'd0;
                end
            end

            RECEIVE_BITS: begin
                // Shift in current bit (LSB first)
                next_shift_reg = {in, shift_reg[7:1]};
                if (bit_count == 3'd7) begin
                    // All 8 bits received
                    next_state = VERIFY_STOP;
                end else begin
                    next_bit_count = bit_count + 3'd1;
                end
            end

            VERIFY_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit valid
                    done_next = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit invalid, go to error recovery
                    next_state = ERROR_RECOVERY;
                end
            end

            ERROR_RECOVERY: begin
                // Wait for line to go idle (1)
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule