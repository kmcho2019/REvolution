module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3] == 1'b1) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign done = (current_state == BYTE3);

endmodule