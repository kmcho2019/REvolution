module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for data bits
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0, will be set to 1 in STOP state if stop bit correct
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Nothing to do here
                end
                START: begin
                    // Nothing to do here
                end
                DATA: begin
                    // Shift in data bits on each clock
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit, output byte and assert done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Nothing to do here
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = START;
            end
            START: begin
                // Move immediately to DATA on next clock
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
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
            end
        endcase
    end

endmodule