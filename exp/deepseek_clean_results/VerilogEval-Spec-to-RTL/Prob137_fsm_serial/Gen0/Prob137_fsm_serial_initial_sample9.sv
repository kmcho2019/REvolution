module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP,
        WAIT
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition and data sampling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin
                        shift_reg <= 0;  // Prepare to receive new byte
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1) begin
                        done <= 1;  // Valid stop bit
                    end
                end

                WAIT: begin
                    // Just waiting for line to return to 1
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) begin
                    next_state = RECEIVE;
                end
            end

            RECEIVE: begin
                if (bit_count == 7) begin
                    next_state = STOP;
                end
            end

            STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end

            WAIT: begin
                if (in == 1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule