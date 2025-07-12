module sequence_detector (
    input  wire clk,
    input  wire reset,         // Active-high synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding representing matched bits count in "1001"
    // 0 = no match yet (IDLE)
    // 1 = matched '1'
    // 2 = matched '10'
    // 3 = matched '100'
    parameter S0 = 2'd0;
    parameter S1 = 2'd1;
    parameter S2 = 2'd2;
    parameter S3 = 2'd3;

    reg [1:0] state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: next_state = data_in ? S1 : S0;   // If input=1, move to S1; else stay
            S1: next_state = data_in ? S1 : S2;   // If input=1, stay S1; else move S2
            S2: next_state = data_in ? S1 : S3;   // If input=1, move S1 (overlap), else S3
            S3: next_state = data_in ? S1 : S0;   // If input=1, move S1, else reset to S0
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected asserted one cycle when full sequence detected
    // The sequence "1001" completes when current state = S3 and input = 1 (the last bit)
    always @(posedge clk) begin
        if (reset)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && data_in;
    end

endmodule