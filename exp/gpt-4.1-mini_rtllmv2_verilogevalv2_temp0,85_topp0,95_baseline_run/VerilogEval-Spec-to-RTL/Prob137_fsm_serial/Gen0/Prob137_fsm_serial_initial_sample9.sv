module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        DATA = 2'b01,
        STOP_CHECK = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count; // count 0 to 7 for data bits

    // Sequential logic: state and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            // done is asserted for one clock cycle only on successful byte reception
            if (state == STOP_CHECK && in == 1) 
                done <= 1;
            else 
                done <= 0;

            // increment bit_count only in DATA state
            if (state == DATA) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0) // start bit detected
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 7) // after receiving last data bit
                    next_state = STOP_CHECK;
                else
                    next_state = DATA;
            end
            STOP_CHECK: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule