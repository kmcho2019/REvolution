module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // Define FSM states
    typedef enum reg [1:0] {
        WAIT_START = 2'b00,
        BYTE2      = 2'b01,
        BYTE3      = 2'b10
    } state_t;

    state_t state, next_state;

    wire start_byte = in[3];

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_START: 
                if (start_byte)
                    next_state = BYTE2;
                else
                    next_state = WAIT_START;
            BYTE2:
                next_state = BYTE3;
            BYTE3:
                next_state = WAIT_START;
            default:
                next_state = WAIT_START;
        endcase
    end

    // Sequential state update and done generation
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done  <= 1'b0;
        end else begin
            state <= next_state;

            // done is high for one cycle right after BYTE3 state completes,
            // so done is high when next_state == WAIT_START AND current state == BYTE3
            done <= (state == BYTE3);
        end
    end

endmodule