module fsm(
    input  wire IN,     // Input signal to the FSM
    input  wire CLK,    // Clock signal (rising edge triggered)
    input  wire RST,    // Asynchronous reset (active high)
    output wire MATCH   // Output asserted when sequence "10011" detected
);

    // State encoding representing how many bits matched in sequence "1 0 0 1 1"
    localparam [2:0]
        S0 = 3'd0,  // No bits matched yet
        S1 = 3'd1,  // Matched '1'
        S2 = 3'd2,  // Matched '10'
        S3 = 3'd3,  // Matched '100'
        S4 = 3'd4;  // Matched '1001'

    reg [2:0] state, next_state;

    // Combinational logic: Determine next_state based on current state and input IN
    always @(*) begin
        case (state)
            S0: begin
                // Starting state: expect first bit '1' to move to S1, else remain
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1', expect '0' to move to S2 or '1' to stay in S1 (overlapping start)
                if (IN == 1'b0)
                    next_state = S2;
                else // IN == 1
                    next_state = S1;
            end

            S2: begin
                // Matched '10', expect '0' to move to S3 or '1' to restart matching from S1
                if (IN == 1'b0)
                    next_state = S3;
                else // IN == 1
                    next_state = S1;
            end

            S3: begin
                // Matched '100', expect '1' to move to S4 or '0' reset to S0
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                // Matched '1001', if input '1' full sequence matched and restart at S1 (overlap)
                // If '0' partial overlap moves to S2 to continue matching sequence
                if (IN == 1'b1)
                    next_state = S1;
                else // IN == 0
                    next_state = S2;
            end

            default: next_state = S0; // Default to initial state on invalid state encoding
        endcase
    end

    // Sequential logic: update state on rising clock edge or asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;   // Reset FSM state to initial state asynchronously
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH is asserted when current state is S4 and IN=1, indicating complete detection
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule