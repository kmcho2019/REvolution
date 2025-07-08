module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // counts from 0 to 7 for 8 bits

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done unless explicitly set below

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // start bit detected
                        bit_count <= 3'b0;
                        shift_reg <= 8'b0;
                    end
                end
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // nothing special except looking for stop bit
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
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

endmodule