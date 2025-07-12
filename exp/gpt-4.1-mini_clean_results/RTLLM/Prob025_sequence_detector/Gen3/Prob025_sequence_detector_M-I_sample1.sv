module sequence_detector (
    input  wire clk,
    input  wire reset,          // Active-high synchronous reset as per spec
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparam for synthesis compatibility
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4; // final matched state

    reg [2:0] state, next_state;

    // Next state logic: Moore FSM transitions based on current state and input
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1; // first bit '1' matched
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)
                    next_state = S2; // second bit '0' matched
                else
                    next_state = S1; // stay if input still '1' (could be start of new sequence)
            end

            S2: begin
                if (~data_in)
                    next_state = S3; // third bit '0' matched
                else
                    next_state = S1; // input '1' - restart detection from S1 (potential sequence start)
            end

            S3: begin
                if (data_in)
                    next_state = S4; // fourth bit '1' matched - full sequence detected
                else
                    next_state = IDLE; // mismatch, restart detection
            end

            S4: begin
                // After sequence detected, check input to determine next state for overlapping sequence detection
                if (data_in)
                    next_state = S1; // possible start of new sequence
                else
                    next_state = S2; // could be partial sequence continuing
            end

            default: next_state = IDLE;
        endcase
    end

    // State and output update on rising clock edge, synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only in S4 state (Moore output)
            sequence_detected <= (next_state == S4);
        end
    end

endmodule