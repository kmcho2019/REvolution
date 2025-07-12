module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;
    
    state_t state, next_state;

    reg [2:0] bit_count; // to count 8 data bits
    reg [7:0] shift_reg;

    // State transitions and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default to 0; only asserted in STOP if valid

            case(state)
                IDLE: begin
                    if (in == 1'b0) // start bit detected
                        bit_count <= 3'd0;
                end
                START: begin
                    // no action here, wait to move to DATA
                end
                DATA: begin
                    // shift in data bits, LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        // valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // nothing here; wait for stop bit detected in next_state logic
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Wait for start bit (in == 0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit and move to DATA
                // Since input is synchronous, start bit verified by staying in START one cycle
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) 
                    next_state = STOP;
                else
                    next_state = DATA;
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
        endcase
    end

endmodule