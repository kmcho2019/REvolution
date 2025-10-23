module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (2-bit binary)
    localparam [1:0]
        IDLE  = 2'b00,
        DATA  = 2'b01,
        STOP  = 2'b10,
        ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // Count bits received in DATA state (0 to 7)
    reg [7:0] shift_reg;      // LSB-first shift register

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)        // Start bit detected (line goes low)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;   // Valid stop bit, ready for next byte
                else
                    next_state = ERROR;  // Framing error, wait for stop bit
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;   // Recover from error on stop bit
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state transitions, counters, shift reg, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low to minimize toggling
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    bit_count <= bit_count + 1'b1;
                    // Shift left by one, new bit into LSB for LSB-first reception
                    shift_reg <= {shift_reg[6:0], in};
                end

                STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b1)
                        done <= 1'b1;   // Pulse done on valid stop bit
                end

                ERROR: begin
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

endmodule