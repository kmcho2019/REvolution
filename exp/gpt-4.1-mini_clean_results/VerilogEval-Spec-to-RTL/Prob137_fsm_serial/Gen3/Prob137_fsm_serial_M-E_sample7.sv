module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum logic [1:0] {
        WAIT_START = 2'b00,
        SHIFT_DATA = 2'b01,
        WAIT_STOP  = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] data_reg;
    reg [2:0] bit_count;

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_START: begin
                if (in == 1'b0)
                    next_state = SHIFT_DATA;
                else
                    next_state = WAIT_START;
            end
            SHIFT_DATA: begin
                if (bit_count == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = SHIFT_DATA;
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = WAIT_START;
                else
                    next_state = WAIT_STOP; // wait until stop bit 1 to resync
            end
            default: next_state = WAIT_START;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            data_reg <= 8'b0;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no pulse

            case(state)
                WAIT_START: begin
                    data_reg <= 8'b0;
                    bit_count <= 3'b0;
                end
                SHIFT_DATA: begin
                    // Shift in LSB first by shifting left, inserting new bit at LSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                WAIT_STOP: begin
                    if (in == 1'b1 && state != next_state) begin
                        // stop bit correct and on transition out of WAIT_STOP assert done
                        done <= 1'b1;
                    end
                    // else stay here waiting for stop bit=1 to resync without done
                end
            endcase
        end
    end

endmodule