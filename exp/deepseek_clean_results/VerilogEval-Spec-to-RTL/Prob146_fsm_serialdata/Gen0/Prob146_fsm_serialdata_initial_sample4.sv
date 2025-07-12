module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // done is only high for one cycle

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin  // start bit detected
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // shift right (LSB first)
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1) begin  // valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 7) next_state = STOP;
            end

            STOP: begin
                if (in == 1) next_state = IDLE;
            end
        endcase
    end

endmodule