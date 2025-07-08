module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2,
        BYTE3 = 2'd3
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == BYTE3)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    always @(*) begin
        // Default next state is current state
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
        endcase
    end

endmodule