module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding (binary)
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        CHECK_STOP = 2'd2,
        WAIT_STOP  = 2'd3
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state and data updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default deassert

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift right, new bit into MSB is in, 
                    // but since LSB first, insert in LSB and shift left:
                    // Actually, as serial LSB first, we should shift right inserting MSB
                    // However, previous code used {in, shift_reg[7:1]}, meaning shift right with in as MSB.
                    // That was reverse. LSB first means first bit received is bit 0.
                    // So shifting right inserting MSB reverses order. Let's instead shift left inserting LSB:
                    // On every clock, shift left and insert new bit at bit 0.
                    // So: shift_reg <= {in, shift_reg[7:1]} as before reverses order, so we correct now:
                    // shift_reg <= {shift_reg[6:0], in};
                    shift_reg <= {shift_reg[6:0], in};
                    bit_cnt <= bit_cnt + 1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // if stop bit invalid, wait_stop handled by FSM, no output change here
                end

                WAIT_STOP: begin
                    // no operations except waiting for line = 1
                end

                default: ;
            endcase
        end
    end

endmodule