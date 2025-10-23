module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        BYTE1 = 2'd1,
        BYTE2 = 2'd2
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and done logic
    always @(*) begin
        done = 1'b0; // default

        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end

            BYTE1: begin
                next_state = BYTE2;
            end

            BYTE2: begin
                next_state = IDLE;
                done = 1'b1; // done asserted after receiving 3rd byte
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule