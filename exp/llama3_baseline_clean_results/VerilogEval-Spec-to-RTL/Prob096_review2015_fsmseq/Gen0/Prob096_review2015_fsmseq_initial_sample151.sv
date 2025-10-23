module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
enum {IDLE, S1, S2, S3, S4, FINAL} state, next_state;

// Initial state assignment
initial state = IDLE;

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data == 1'b1) next_state = S2;
            else if (data == 1'b0) next_state = IDLE;
        end
        S2: begin
            if (data == 1'b0) next_state = S3;
            else if (data == 1'b1) next_state = S2;
        end
        S3: begin
            if (data == 1'b1) next_state = S4;
            else if (data == 1'b0) next_state = IDLE;
        end
        S4: begin
            if (data == 1'b1) next_state = S1;
            else if (data == 1'b0) next_state = FINAL;
        end
        FINAL: next_state = FINAL;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == FINAL) start_shifting <= 1'b1;
        else if (state != FINAL && next_state == FINAL) start_shifting <= 1'b1;
        else start_shifting <= 1'b0;
    end
end

endmodule