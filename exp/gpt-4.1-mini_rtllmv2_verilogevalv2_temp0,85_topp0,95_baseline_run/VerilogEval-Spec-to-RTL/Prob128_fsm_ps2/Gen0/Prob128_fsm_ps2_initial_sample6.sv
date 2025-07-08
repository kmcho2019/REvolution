module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // State transition and done logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // done is asserted only on the cycle after receiving the third byte
            // which corresponds to the transition from BYTE3 state to IDLE or BYTE2
            if (state == BYTE3) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold state
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                // second byte received, move to BYTE3
                next_state = BYTE3;
            end
            BYTE3: begin
                // after third byte, look for next message start
                if (in[3] == 1'b1)
                    next_state = BYTE2; // immediately start next message
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule