module fsm (
    input  wire IN,     // Input bit stream
    input  wire CLK,    // Clock signal (rising edge triggered)
    input  wire RST,    // Asynchronous reset (active high)
    output wire MATCH   // Output high when sequence "10011" detected at current input
);

    // State encoding - number of matched bits in sequence "1 0 0 1 1"
    localparam [2:0]
        S0 = 3'd0,  // No bits matched yet
        S1 = 3'd1,  // Matched '1'
        S2 = 3'd2,  // Matched '10'
        S3 = 3'd3,  // Matched '100'
        S4 = 3'd4;  // Matched '1001'

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: begin
                // Waiting for first '1' in the sequence
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1', next expected '0'
                if (IN == 1'b0)
                    next_state = S2;
                else
                    // If input is '1', still possible start of sequence, stay at S1
                    next_state = S1;
            end

            S2: begin
                // Matched '10', next expected '0'
                if (IN == 1'b0)
                    next_state = S3;
                else
                    // If input is '1', possible start of new sequence, go to S1
                    next_state = S1;
            end

            S3: begin
                // Matched '100', next expected '1'
                if (IN == 1'b1)
                    next_state = S4;
                else
                    // If input '0', sequence fails, restart from S0
                    next_state = S0;
            end

            S4: begin
                // Matched '1001', next expected '1' to complete sequence
                if (IN == 1'b1)
                    // Sequence complete ("10011" detected)
                    // After match, overlap: next state depends on input for continuous detection
                    next_state = S1; // Because input '1' matches start of new sequence
                else
                    // If '0', could be partial overlap with '100' pattern, go to S2
                    next_state = S2;
            end

            default: next_state = S0; // Safety fallback
        endcase
    end

    // Sequential state register with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when current state is S4 and input IN=1, indicating full sequence detected on current bit
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule