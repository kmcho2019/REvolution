module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg, next_shift_reg;
    reg [2:0] bit_cnt, next_bit_cnt;
    reg done_next;

    // Sequential logic with controlled updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Update bit counter and shift register only in RECEIVE state
            if (state == RECEIVE) begin
                bit_cnt <= next_bit_cnt;
                shift_reg <= next_shift_reg;
            end else begin
                // Hold values in other states
                bit_cnt <= bit_cnt;
                shift_reg <= shift_reg;
            end

            // Latch out_byte and done on done_next
            out_byte <= (done_next) ? shift_reg : out_byte;
            done <= done_next;
        end
    end

    // Combinational next-state and outputs logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_bit_cnt = bit_cnt;
        next_shift_reg = shift_reg;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    // Start bit detected, prepare for data bits
                    next_state = RECEIVE;
                    next_bit_cnt = 3'd0;
                    next_shift_reg = 8'd0;
                end
            end

            RECEIVE: begin
                // Shift in LSB first: new bit in LSB position
                next_shift_reg = {in, shift_reg[7:1]};
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_bit_cnt = bit_cnt + 1;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit: done and return to idle
                    done_next = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit: wait for stop bit
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit finally detected: back to idle
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule