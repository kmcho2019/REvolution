module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        MATCH
    } state_t;

    state_t current_state, next_state;
    wire clk_gated = clk & (~start_shifting | reset);

    always @(posedge clk_gated) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S2 : IDLE;
            S2:   next_state = data ? S2 : S3;
            S3:   next_state = data ? MATCH : IDLE;
            MATCH: next_state = MATCH;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (current_state == S3 && data) begin
            start_shifting <= 1'b1;
        end
    end

endmodule