module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3
    } state_t;

    // State register
    state_t state, next_state;

    // Sequential logic for state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            IDLE: begin
                done = 1'b0;
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                done = 1'b0;
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                done = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

endmodule