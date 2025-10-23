module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary, 2 bits)
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg, next_shift_reg;
    reg [2:0] bit_cnt, next_bit_cnt;
    reg done_next;

    // Enable signals derived from next_state for clarity and gating
    wire receive_enable = (next_state == RECEIVE);

    // Sequential block: update state, counters, shift register, and outputs on clock edge
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_cnt    <= 3'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state      <= next_state;
            bit_cnt    <= next_bit_cnt;
            shift_reg  <= next_shift_reg;
            done       <= done_next;
            // Latch out_byte only when done_next asserted
            if (done_next)
                out_byte <= shift_reg;
        end
    end

    // Combinational block: determine next state, outputs, and shift register behavior
    always @(*) begin
        // Default assignments: hold current values
        next_state     = state;
        next_bit_cnt   = bit_cnt;
        next_shift_reg = shift_reg;
        done_next      = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0) begin
                    next_state     = RECEIVE;
                    next_bit_cnt   = 3'd0;
                    next_shift_reg = 8'd0;  // Clear shift register at start
                end
            end

            RECEIVE: begin
                // Shift in LSB first: shift right, input bit goes to MSB
                // (Because serial sends LSB first, first bit received is LSB)
                next_shift_reg = {in, shift_reg[7:1]};
                if (bit_cnt == 3'd7) begin
                    next_state = CHECK_STOP;
                end else begin
                    next_bit_cnt = bit_cnt + 1'b1;
                end
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit detected: output data and assert done for 1 cycle
                    done_next  = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit invalid, wait for line to return to idle (1)
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                // Wait here until line returns to idle (logic 1)
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule