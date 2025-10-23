module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states - keeping 2-bit encoding for area efficiency
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP,
        WAIT
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;  // Clock gating control

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1) ? IDLE : WAIT;
            WAIT:    next_state = (in == 1) ? IDLE : WAIT;
        endcase
    end

    // State and data path (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
            shift_enable <= 0;
        end else begin
            state <= next_state;
            done <= 0;
            shift_enable <= 0;

            case (next_state)
                IDLE: begin
                    bit_count <= 0;
                end

                RECEIVE: begin
                    shift_enable <= 1;
                    if (shift_enable) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1) begin
                        done <= 1;
                    end
                end

                WAIT: begin
                    // No operation needed
                end
            endcase
        end
    end

endmodule