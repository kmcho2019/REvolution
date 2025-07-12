module sequence_detector (
    input  wire clk,
    input  wire reset,          // synchronous active-high reset (per user spec: "When reset is high...")
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (3-bit minimum for 5 states)
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;  // detected '1'
    localparam S2   = 3'd2;  // detected "10"
    localparam S3   = 3'd3;  // detected "100"
    localparam S4   = 3'd4;  // detected "1001" (final detection)

    reg [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy FSM)
    reg detected;
    always @(*) begin
        detected = 1'b0;
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (~data_in)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // Output detected asserted in this state
                detected = 1'b1;
                // After detection, determine next state based on current input
                if (data_in)
                    next_state = S1;  // overlapping detection support
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                detected = 1'b0;
            end
        endcase
    end

    assign sequence_detected = detected;

endmodule