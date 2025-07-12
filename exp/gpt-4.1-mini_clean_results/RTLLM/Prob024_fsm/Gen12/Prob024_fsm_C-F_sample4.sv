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

    // Next state logic with clear, explicit conditions and minimal redundant transitions
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;

            S1: next_state = (IN == 1'b0) ? S2 : S1;

            S2: next_state = (IN == 1'b0) ? S3 : S1;

            S3: next_state = (IN == 1'b1) ? S4 : S0;

            S4: begin
                // After full match, handle overlapping sequences explicitly:
                if (IN == 1'b1)
                    next_state = S1; // restart matching at '1'
                else if (IN == 1'b0)
                    next_state = S2; // partial match of '10'
                else
                    next_state = S0; // fallback, though IN is binary
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