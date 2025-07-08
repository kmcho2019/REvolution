module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,      // no bits matched
        S1 = 3'd1,        // matched '1'
        S11 = 3'd2,       // matched '11'
        S110 = 3'd3,      // matched '110'
        FOUND = 3'd4      // sequence found
    } state_t;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case(state)
            IDLE: begin
                if(data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if(data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if(data)
                    next_state = S11;    // because sequence 111.. could overlap 1101, but we want to track only 1101
                else
                    next_state = S110;
            end
            S110: begin
                if(data)
                    next_state = FOUND;  // matched 1101
                else
                    next_state = IDLE;
            end
            FOUND: begin
                next_state = FOUND;      // stay here until reset
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and start_shifting output register
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if(state == FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule