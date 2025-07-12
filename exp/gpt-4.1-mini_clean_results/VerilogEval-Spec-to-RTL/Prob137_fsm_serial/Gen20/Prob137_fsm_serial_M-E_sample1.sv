module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states (binary encoding)
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        ERROR      = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_cnt;            // 0 to 8 bits received; counts from 0 to 7 during RECEIVE
    reg [7:0] data_accumulator;

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (logic 0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 4'd7)
                    next_state = CHECK_STOP; // After receiving 8 bits, check stop bit
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Valid stop bit: next byte can start
                else
                    next_state = ERROR;    // Framing error: wait for idle line
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Line idle detected, ready for new start bit
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, bit counter, data accumulator, done signal
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            data_accumulator <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default no done pulse

            case (state)
                IDLE: begin
                    bit_cnt <= 4'd0;
                    data_accumulator <= 8'd0;
                    // Wait for start bit; nothing else to do
                end

                RECEIVE: begin
                    // Shift in bits LSB first: shift right and insert new bit at MSB
                    data_accumulator <= {in, data_accumulator[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end

                CHECK_STOP: begin
                    // If stop bit valid, pulse done one cycle
                    if (in == 1'b1)
                        done <= 1'b1;
                    // Otherwise done=0, error handled by FSM transition
                end

                ERROR: begin
                    // Hold accumulator and bit counter until line idle
                    // Nothing to update here
                end
            endcase
        end
    end

endmodule