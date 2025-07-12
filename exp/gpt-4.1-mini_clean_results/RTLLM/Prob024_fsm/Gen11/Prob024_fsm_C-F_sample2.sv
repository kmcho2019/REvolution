module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding representing matched prefix lengths:
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic using combinational always block for clarity and easy debugging
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;

            S1: next_state = (IN == 1'b0) ? S2 : S1;

            S2: next_state = (IN == 1'b0) ? S3 : S1; // on mismatch, restart from S1 if IN=1

            S3: next_state = (IN == 1'b1) ? S4 : S0;

            S4: begin
                // After full match, handle overlapping sequences:
                // if IN=1, restart matching prefix '1'
                // if IN=0, move to S2 (matched '10'), else reset to S0 (should not occur as IN is 0 or 1)
                if (IN == 1'b1)
                    next_state = S1;
                else // IN == 0
                    next_state = S2;
            end

            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is asserted immediately when sequence "10011" completes,
    // i.e., currently at S4 and input bit is '1'
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule