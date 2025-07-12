module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP_WAIT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;  // counts 0 to 7 data bits received
    reg [7:0] data_reg;   // to store data bits (not used output but helps debug or extend)

    // Next state logic and outputs
    always @(*) begin
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end
            STOP_WAIT: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1; // done asserted for one clock cycle
                end
                else
                    next_state = STOP_WAIT; // wait for valid stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic - state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    done <= 1'b0;
                end
                RECEIVE: begin
                    // Shift in data bit (LSB first)
                    data_reg <= {in, data_reg[7:1]};
                    if (bit_count < 3'd7)
                        bit_count <= bit_count + 1'b1;
                    done <= 1'b0;
                end
                STOP_WAIT: begin
                    if (in == 1'b1)
                        done <= 1'b1; // done is synchronous asserted here
                    else
                        done <= 1'b0;
                end
                default: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule