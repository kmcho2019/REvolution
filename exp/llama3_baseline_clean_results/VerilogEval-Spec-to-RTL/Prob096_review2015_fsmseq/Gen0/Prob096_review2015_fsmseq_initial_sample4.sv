module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states of the FSM
enum logic [2:0] {IDLE, S1, S2, S3, MATCHED} state, next_state;

// Initial state is IDLE
initial state = IDLE;

// Combinational logic to determine next state
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data == 1) next_state = S2;
            else if (data == 0) next_state = IDLE;
            else next_state = S1; // This line is redundant and can be removed
        end
        S2: begin
            if (data == 0) next_state = S3;
            else if (data == 1) next_state = S1;
            else next_state = S2; // This line is redundant and can be removed
        end
        S3: begin
            if (data == 1) next_state = MATCHED;
            else next_state = IDLE;
        end
        MATCHED: begin
            next_state = MATCHED;
        end
    endcase
end

// Sequential logic to update state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end
    else begin
        state <= next_state;
        if (state == MATCHED) start_shifting <= 1;
        else if (state != MATCHED) start_shifting <= 0;
    end
end

endmodule