module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'b00,
        RECEIVE = 2'b01,
        STOP    = 2'b10
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;   // counts data bits 0..7
    reg [7:0] data_reg;    // stores the received byte (LSB first)

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
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
                if (in == 1'b1) // valid stop bit
                    next_state = IDLE;
                else
                    next_state = STOP; // wait for valid stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, data, done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no pulse

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    // wait for start bit
                end

                RECEIVE: begin
                    // Capture current bit into data_reg at bit_count position (LSB first)
                    data_reg[bit_count] <= in;
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;  // Assert done for one cycle
                    end
                    // else remain in STOP until stop bit valid
                end

                default: begin
                    // Safe default
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule