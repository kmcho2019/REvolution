module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

always_comb begin
    case (state)
        IDLE: begin
            if (data == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data == 1'b1) next_state = S2;
            else if (data == 1'b0) next_state = IDLE;
            else next_state = S1; // This line will never be executed, just for completeness
        end
        S2: begin
            if (data == 1'b0) next_state = S3;
            else if (data == 1'b1) next_state = S2;
            else next_state = S2; // This line will never be executed, just for completeness
        end
        S3: begin
            if (data == 1'b1) next_state = S3;
            else if (data == 1'b0) next_state = S4;
            else next_state = S3; // This line will never be executed, just for completeness
        end
        S4: begin
            next_state = S4;
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S4) start_shifting <= 1'b1;
        else start_shifting <= 1'b0;
    end
end

endmodule