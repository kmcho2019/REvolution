module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched 1
        S11 = 3'd2, // matched 11
        S110 = 3'd3, // matched 110
        S_FOUND = 3'd4 // sequence found
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if(data == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if(data == 1'b1)
                    next_state = S11;
                else
                    next_state = S0;
            end

            S11: begin
                if(data == 1'b0)
                    next_state = S110;
                else
                    next_state = S11; // stays in S11 if input is 1
            end

            S110: begin
                if(data == 1'b1)
                    next_state = S_FOUND;
                else
                    next_state = S0;
            end

            S_FOUND: begin
                next_state = S_FOUND; // once found, stay here
            end

            default: next_state = S0;
        endcase
    end

    // State and output update at clock edge with synchronous reset
    always @(posedge clk) begin
        if(reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if(next_state == S_FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule