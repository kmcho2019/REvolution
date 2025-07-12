module sequence_detector (
    input  wire clk,
    input  wire reset,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using parameters for portability
    parameter IDLE = 3'd0,
              S1   = 3'd1,  // matched '1'
              S2   = 3'd2,  // matched '10'
              S3   = 3'd3,  // matched '100'
              S4   = 3'd4;  // matched '1001' (detected full sequence)

    reg [2:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic (Mealy FSM) based on current state and input
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;    // got first '1'
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)
                    next_state = S2;    // matched '10'
                else
                    next_state = S1;    // still reading '1', stay in S1 (overlapping)
            end

            S2: begin
                if (!data_in)
                    next_state = IDLE;  // sequence breaks, back to IDLE
                else
                    next_state = S3;    // matched '100'
            end

            S3: begin
                if (data_in)
                    next_state = S4;    // matched full '1001'
                else
                    next_state = S2;    // sequence restart from second bit '0' in '10'
            end

            S4: begin
                // After detection, check next input to allow overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = S2;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected is asserted combinationally in Mealy style
    always @(*) begin
        sequence_detected = 1'b0;
        if (state == S3 && data_in == 1'b1) begin
            // On transition from S3 to S4 (input bit '1' completes sequence)
            sequence_detected = 1'b1;
        end
    end

endmodule