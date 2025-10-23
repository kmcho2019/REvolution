module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define the states of the finite-state machine
typedef enum logic[1:0] {
    S_IDLE,
    S_SAW_1,
    S_SAW_11,
    S_SAW_110
} state_t;

state_t state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        S_IDLE: begin
            if (data == 1'b1)
                next_state = S_SAW_1;
            else
                next_state = S_IDLE;
        end
        S_SAW_1: begin
            if (data == 1'b1)
                next_state = S_SAW_11;
            else
                next_state = S_IDLE;
        end
        S_SAW_11: begin
            if (data == 1'b0)
                next_state = S_SAW_110;
            else
                next_state = S_SAW_1;
        end
        S_SAW_110: begin
            if (data == 1'b1)
                next_state = S_SAW_110; // Transition to final state
            else
                next_state = S_IDLE;
        end
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S_SAW_110)
            start_shifting <= 1'b1;
        else if (next_state == S_SAW_110)
            start_shifting <= 1'b1;
        else
            start_shifting <= 1'b0;
    end
end

endmodule