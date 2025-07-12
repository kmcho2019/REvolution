module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// State encoding for FSM to detect "1101"
typedef enum reg [2:0] {
    S0 = 3'd0, // no bits matched
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched '11'
    S3 = 3'd3, // matched '110'
    S4 = 3'd4  // matched '1101' (final state)
} state_t;

reg [2:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        // Once the sequence is found, start_shifting stays 1 forever until reset
        if (start_shifting == 1'b1)
            start_shifting <= 1'b1;
        else if (next_state == S4)
            start_shifting <= 1'b1;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (data == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (data == 1'b1)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (data == 1'b0)
                next_state = S3;
            else
                next_state = S2; // stay in S2 if input 1 (because multiple 1s could appear)
        end
        S3: begin
            if (data == 1'b1)
                next_state = S4; // Sequence matched
            else
                next_state = S0;
        end
        S4: begin
            // Once in S4, stay here, output latched
            next_state = S4;
        end
        default: next_state = S0;
    endcase
end

endmodule