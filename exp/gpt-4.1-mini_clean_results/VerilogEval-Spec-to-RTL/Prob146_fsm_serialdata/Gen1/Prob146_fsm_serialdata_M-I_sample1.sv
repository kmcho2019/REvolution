module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        START = 2'd1,
        RECEIVE = 2'd2,
        STOP = 2'd3
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // counts from 0 to 7

    reg [7:0] shift_reg;

    // Sequential logic: state transitions, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low unless asserted below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    // Shift left and insert new bit at LSB to get LSB-first order
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 3'd1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit, latch output and assert done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // else remain in STOP waiting for stop bit
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START; // detect start bit
                else
                    next_state = IDLE;
            end

            START: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // confirmed stable start bit
                else
                    next_state = IDLE; // false start, return to idle
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // after 8 data bits received
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit received, ready for next byte
                else
                    next_state = STOP; // wait for stop bit
            end

            default: next_state = IDLE;
        endcase
    end

endmodule