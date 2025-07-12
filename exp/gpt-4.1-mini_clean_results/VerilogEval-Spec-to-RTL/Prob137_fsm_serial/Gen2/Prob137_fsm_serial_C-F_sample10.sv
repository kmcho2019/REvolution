module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // FSM states encoding
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        CHECK_STOP = 2'd2,
        WAIT_STOP  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;   // Counts data bits received: 0 to 7
    reg [7:0] shift_reg;   // Shift register to store data bits (LSB first)

    // Sequential logic: state, bit_count, shift_reg, and done update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Default done cleared each cycle
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in received bit into LSB, shift right
                    // LSB-first means first received bit goes to bit0,
                    // subsequent bits shift older bits right.
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                CHECK_STOP: begin
                    // If stop bit valid (in==1), assert done one cycle
                    if (in == 1'b1)
                        done <= 1'b1;
                    // No change to bit_count or shift_reg here
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= shift_reg; // hold shift_reg stable (optional)
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
        next_state = state;
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits (bit_count == 7), check stop bit next
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                // If stop bit correct (1), go to IDLE, else WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait until line returns high (stop bit)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule