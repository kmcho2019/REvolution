module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // One-hot state encoding (3 states)
    localparam S0 = 3'b001; // Initial state: no bits matched
    localparam S1 = 3'b010; // Matched '1'
    localparam S2 = 3'b100; // Matched '10'

    reg [2:0] state, next_state;

    // Next state logic: combinational
    always @(*) begin
        case (state)
            S0: begin
                // Waiting for first '1' of sequence
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                // Have matched '1', waiting for '0'
                if (x)
                    next_state = S1; // Stay if another '1' (overlapping sequences)
                else
                    next_state = S2; // Matched '10', waiting for last '1'
            end
            S2: begin
                // Have matched '10', waiting for final '1'
                if (x)
                    next_state = S1; // Sequence "101" detected, restart from matched '1'
                else
                    next_state = S0; // No match, reset
            end
            default: next_state = S0; // Safety default
        endcase
    end

    // Output logic (Mealy): asserted on detection of sequence "101"
    always @(*) begin
        // Sequence detected if in S2 and input x == 1
        z = (state == S2) && x;
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule