module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default done to 0 every cycle
            if (state == BYTE3)
                done <= 1'b1;  // signal done after receiving third byte
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;  // start of message detected
                else
                    next_state = IDLE;
            end
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule