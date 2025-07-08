module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // no match yet
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '11'
        S3 = 3'b011, // matched '110'
        S4 = 3'b100  // matched '1101' -> output set
    } state_t;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        if (start_shifting) begin
            // Once start_shifting is set, remain in S4
            next_state = S4;
        end else begin
            case(state)
                S0: next_state = (data) ? S1 : S0;
                S1: next_state = (data) ? S2 : S0;
                S2: next_state = (data) ? S2 : S3;
                S3: next_state = (data) ? S4 : S0;
                S4: next_state = S4;
                default: next_state = S0;
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (next_state == S4)
                start_shifting <= 1;
        end
    end

endmodule