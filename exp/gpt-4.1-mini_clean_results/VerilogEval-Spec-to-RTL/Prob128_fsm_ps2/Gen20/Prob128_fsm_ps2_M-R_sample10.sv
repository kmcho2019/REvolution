module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    wire start_byte = in[3];

    // State transition logic
    always @(*) begin
        done = 1'b0;  // default done low
        case (state)
            IDLE: begin
                if (start_byte)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end

            BYTE2: next_state = BYTE3;

            BYTE3: begin
                done = 1'b1;  // done asserted after third byte
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule