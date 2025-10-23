module sequence_detector (
    input  wire clk,
    input  wire reset,          // Active-high synchronous reset as per problem description
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding representing matched bits of sequence "1001"
    localparam S0 = 2'd0;  // No bits matched
    localparam S1 = 2'd1;  // Matched '1'
    localparam S2 = 2'd2;  // Matched '10'
    localparam S3 = 2'd3;  // Matched '100'

    reg [1:0] state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: next_state = data_in ? S1 : S0;
            S1: next_state = data_in ? S1 : S2;
            S2: next_state = data_in ? S1 : S3;
            S3: next_state = data_in ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected asserted 1 cycle when sequence "1001" detected
    always @(posedge clk) begin
        if (reset)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && data_in;
    end

endmodule