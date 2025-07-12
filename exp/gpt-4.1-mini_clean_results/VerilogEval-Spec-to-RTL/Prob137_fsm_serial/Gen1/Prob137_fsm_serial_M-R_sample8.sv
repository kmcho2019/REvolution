module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP_WAIT = 2'b10
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;   // Counts number of data bits received (0 to 7)
    reg [7:0] data_reg;    // Shift register to store received data (LSB first)

    // Sequential block: state register, counters, data shift, and done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, assert for one cycle only

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in data bit LSB first: shift left, new bit into LSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // valid stop bit detected, assert done pulse
                    end
                    // else remain in STOP_WAIT, do not clear bit_count or data_reg here to keep data stable if needed
                end

                default: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold state
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // After receiving 8 bits (0..7)
                    next_state = STOP_WAIT;
            end

            STOP_WAIT: begin
                if (in == 1'b1) // stop bit detected
                    next_state = IDLE;
                // else stay in STOP_WAIT until stop bit found
            end

            default: next_state = IDLE;
        endcase
    end

endmodule