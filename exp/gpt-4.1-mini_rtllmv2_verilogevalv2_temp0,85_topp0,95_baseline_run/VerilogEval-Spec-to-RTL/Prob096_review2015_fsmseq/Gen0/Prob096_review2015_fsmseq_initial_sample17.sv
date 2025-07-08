module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // no match
        S1 = 2'b01, // matched '1'
        S2 = 2'b10, // matched '11'
        S3 = 2'b11  // matched '110'
    } state_t;

    state_t state, next_state;

    // FSM next state logic
    always @(*) begin
        case (state)
            S0: next_state = (data) ? S1 : S0;
            S1: next_state = (data) ? S2 : S0;
            S2: next_state = (data) ? S2 : S3;
            S3: next_state = (data) ? S1 : S0; // When data=1 at S3, full sequence matched (1101)
            default: next_state = S0;
        endcase
    end

    // State update and start_shifting logic on clock
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Once start_shifting is set, it stays 1 until reset
            if (start_shifting == 1'b0 && state == S3 && data == 1'b1) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule