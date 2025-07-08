module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA = 3'b010,
        STOP = 3'b011,
        ERROR_WAIT = 3'b100
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for data bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done, pulse when stop bit received correctly

            case (state)
                IDLE: begin
                    // waiting for start bit low
                    if (in == 1'b0) begin
                        // detected start bit, move to START state
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                START: begin
                    // confirm start bit still 0 on next clock
                    // no other logic needed here, transition handled in FSM below
                end

                DATA: begin
                    // shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // done logic handled below
                end

                ERROR_WAIT: begin
                    // wait until line returns to 1 (stop bit) before resync
                end

                default: ;
            endcase

            // Output logic for done and out_byte handled below FSM next_state logic
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = START;
            end

            START: begin
                // Confirm start bit still 0
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit, back to idle
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default:
                next_state = IDLE;
        endcase
    end

endmodule