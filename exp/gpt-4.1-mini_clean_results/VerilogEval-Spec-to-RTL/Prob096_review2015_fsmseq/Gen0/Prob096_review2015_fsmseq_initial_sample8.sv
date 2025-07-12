module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// State encoding
typedef enum reg [2:0] {
    S0, // Initial state, no bits matched
    S1, // matched '1'
    S2, // matched "11"
    S3, // matched "110"
    S4  // matched "1101" - output asserted
} state_t;

state_t current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= S0;
        start_shifting <= 1'b0;
    end else begin
        current_state <= next_state;
        // Once sequence found, start_shifting stays 1
        if (current_state == S4)
            start_shifting <= 1'b1;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
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
                next_state = S2; // remain since two or more 1's can overlap
        end

        S3: begin
            if (data == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end

        S4: begin
            // Remain in S4 after sequence found
            next_state = S4;
        end

        default: next_state = S0;
    endcase
end

endmodule