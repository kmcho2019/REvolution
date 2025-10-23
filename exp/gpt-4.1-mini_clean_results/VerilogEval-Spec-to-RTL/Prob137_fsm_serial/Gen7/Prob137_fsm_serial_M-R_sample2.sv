module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        CHECK_STOP = 2'b10,
        WAIT_STOP  = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic for state, bit_count, shift_reg
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    bit_count <= bit_count + 1;
                    // Shift left, inserting new bit at LSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                end

                CHECK_STOP: begin
                    bit_count <= 3'd0; // Reset counter after receiving byte
                    // shift_reg unchanged to hold received byte (optional)
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // Detected start bit
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP; // After receiving 8 data bits
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit correct, go idle
                else
                    next_state = WAIT_STOP; // Stop bit error, wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit found, go idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Generate done combinationally: pulse high in CHECK_STOP when stop bit is correct
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule