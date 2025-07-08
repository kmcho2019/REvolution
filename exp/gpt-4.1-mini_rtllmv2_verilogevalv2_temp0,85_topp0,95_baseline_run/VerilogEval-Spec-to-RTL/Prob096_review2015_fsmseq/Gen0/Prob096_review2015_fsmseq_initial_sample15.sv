module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// States representing how many bits matched so far
typedef enum reg [2:0] {
    S0, // No match yet
    S1, // Matched '1'
    S11, // Matched '11'
    S110, // Matched '110'
    S_FOUND // Sequence found
} state_t;

reg [2:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S_FOUND)
            start_shifting <= 1'b1;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (data)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (data)
                next_state = S11;
            else
                next_state = S0;
        end
        S11: begin
            if (data)
                next_state = S11; // Remain if another 1 detected
            else
                next_state = S110;
        end
        S110: begin
            if (data)
                next_state = S_FOUND; // Sequence 1101 found
            else
                next_state = S0;
        end
        S_FOUND: begin
            next_state = S_FOUND; // Stay here indefinitely
        end
        default: next_state = S0;
    endcase
end

endmodule