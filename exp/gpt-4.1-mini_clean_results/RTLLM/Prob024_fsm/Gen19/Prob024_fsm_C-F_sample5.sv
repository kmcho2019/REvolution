module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: matched prefix length of sequence "10011"
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            3'd0: begin
                // Waiting for first '1'
                if (IN == 1'b1)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end

            3'd1: begin
                // Matched '1', expect '0'
                if (IN == 1'b0)
                    next_state = 3'd2;
                else
                    // Stay in state 1 if multiple '1's in a row
                    next_state = 3'd1;
            end

            3'd2: begin
                // Matched '10', expect '0'
                if (IN == 1'b0)
                    next_state = 3'd3;
                else
                    // '1' could be the start of a new sequence
                    next_state = 3'd1;
            end

            3'd3: begin
                // Matched '100', expect '1'
                if (IN == 1'b1)
                    next_state = 3'd4;
                else
                    // No partial match, reset to 0
                    next_state = 3'd0;
            end

            3'd4: begin
                // Matched '1001', expect final '1'
                if (IN == 1'b1)
                    // Sequence "10011" completed, overlap restart from '1'
                    next_state = 3'd1;
                else
                    // Partial overlap matched '10' again
                    next_state = 3'd2;
            end

            default: next_state = 3'd0;
        endcase
    end

    // Sequential logic for state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when sequence "10011" just completed
    // That is when current state is 4 and input IN=1 (last bit of sequence)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule