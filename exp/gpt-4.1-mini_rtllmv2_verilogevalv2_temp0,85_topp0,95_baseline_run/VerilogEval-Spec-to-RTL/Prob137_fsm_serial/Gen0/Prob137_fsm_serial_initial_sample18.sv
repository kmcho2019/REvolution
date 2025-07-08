module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // States
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count; // counts 0 to 7 for data bits

    // Sequential logic: state and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted for one cycle after a successful stop bit
            if (state == STOP && in == 1'b1) 
                done <= 1'b1;
            else 
                done <= 1'b0;

            if (state == DATA)
                bit_count <= bit_count + 3'd1;
            else
                bit_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit still zero, then go to DATA
                // If start bit fails, go back to IDLE
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                // After 8 bits, go to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                // Check stop bit
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, done asserted
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait until stop bit detected
            end
            WAIT_STOP: begin
                // Wait for stop bit (1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule