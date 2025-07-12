module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding representing number of matched bits in sequence "1001"
    // States: 0 (no match), 1 (matched '1'), 2 (matched '10'), 3 (matched '100')
    typedef enum logic [1:0] {
        S0 = 2'd0,
        S1 = 2'd1,
        S2 = 2'd2,
        S3 = 2'd3
    } state_t;

    state_t state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: next_state = data_in ? S1 : S0; // If input=1, move to S1; else stay
            S1: next_state = data_in ? S1 : S2; // If input=1, stay S1; else move S2
            S2: next_state = data_in ? S1 : S3; // If input=1, move S1 (overlap), else S3
            S3: next_state = data_in ? S1 : S0; // If input=1, move S1, else reset to S0
            default: next_state = S0;
        endcase
    end

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected is high when sequence "1001" is detected
    // The sequence completes when in state S3 and data_in = 1 (the last bit)
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            // Output high only one cycle when sequence completes
            sequence_detected <= (state == S3) && data_in;
    end

endmodule