module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP      = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg shift_enable;
    reg done_next;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE:
                next_state = (bit_count == 3'd7) ? STOP : RECEIVE;

            STOP:
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            WAIT_STOP:
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            default:
                next_state = IDLE;
        endcase
    end

    // Shift enable logic: only receive data bits in RECEIVE state
    always @(*) begin
        shift_enable = (state == RECEIVE);
    end

    // Sequential logic: state register and data reception
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low, only set when stop bit correct

            if (shift_enable) begin
                // Shift in LSB first
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
            end else if (state == IDLE && in == 1'b0) begin
                // Reset bit counter and shift register on detecting start bit
                bit_count <= 3'b0;
                shift_reg <= 8'b0;
            end

            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end
        end
    end

endmodule