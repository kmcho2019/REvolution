module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE1 = 2'b01,
        BYTE2 = 2'b10,
        BYTE3 = 2'b11
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // done is only asserted in BYTE3 state's done cycle
            if (state == BYTE3) 
                done <= 1'b1;
            else 
                done <= 1'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in[3] == 1'b1) 
                    next_state = BYTE1;
                else 
                    next_state = IDLE;
            end
            BYTE1: begin
                next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                // done asserted this cycle, next cycle decide where to go
                if (in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule