module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary state encoding
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP,
        WAIT
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:   next_state = (in == 1) ? IDLE : WAIT;
            WAIT:   next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin
                        shift_reg <= 0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                default: begin
                    // No action needed in other states
                end
            endcase
        end
    end

    // Combinational done signal
    always @(*) begin
        done = (state == STOP && in == 1);
    end

endmodule