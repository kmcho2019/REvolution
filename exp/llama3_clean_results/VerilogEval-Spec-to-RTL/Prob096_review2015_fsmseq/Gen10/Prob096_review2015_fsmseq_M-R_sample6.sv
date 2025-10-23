module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (!data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = S4; // Stay in S4 state
        end
    endcase
end

assign start_shifting = (state == S4);

endmodule