module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '11'
        S3 = 3'd3, // matched '110'
        S4 = 3'd4  // sequence 1101 found
    } state_t;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if (data == 1'b1) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (data == 1'b1) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (data == 1'b0) next_state = S3;
                else next_state = S2; // stay in S2 for continuous '1's
            end
            S3: begin
                if (data == 1'b1) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                // Once sequence is found, remain in S4 forever
                next_state = S4;
            end
            default: next_state = S0;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule