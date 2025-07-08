module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        DATA = 2'd1,
        STOP = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count;  // count 0 to 7 for data bits

    // Sequential logic - state and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is one cycle pulse, default 0
            done <= 1'b0;
            if (state == IDLE) begin
                bit_count <= 4'd0;
            end else if (state == DATA) begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end

    // Next state logic and done output
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // wait for start bit 0
                if (in == 1'b0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_count == 4'd7)  // after receiving last data bit
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    // good stop bit, done pulse
                    next_state = IDLE;
                    // done asserted in sequential block on transition from STOP with correct stop bit
                end else begin
                    // bad stop bit, wait until we see a stop bit
                    next_state = WAIT_STOP;
                end
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

    // done pulse logic: asserted for one cycle at STOP state with good stop bit
    always @(posedge clk) begin
        if (!reset && state == STOP && in == 1'b1)
            done <= 1'b1;
    end

endmodule