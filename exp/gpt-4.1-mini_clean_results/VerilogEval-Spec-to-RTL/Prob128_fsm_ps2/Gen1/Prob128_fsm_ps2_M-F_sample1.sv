module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  in,
    output reg         done
);

    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        BYTE1 = 3'd1,
        BYTE2 = 3'd2,
        BYTE3 = 3'd3,
        DONE  = 3'd4
    } state_t;

    state_t state, next_state;

    // Sequential logic: state transition and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted only in DONE state, else cleared
            done <= (next_state == DONE);
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for a byte with in[3]==1 to mark start of message
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end

            BYTE1: begin
                // Move on to second byte regardless of its content
                next_state = BYTE2;
            end

            BYTE2: begin
                // Move on to third byte
                next_state = BYTE3;
            end

            BYTE3: begin
                // After third byte, go to DONE to assert done signal
                next_state = DONE;
            end

            DONE: begin
                // One clock cycle with done asserted, then back to IDLE
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule