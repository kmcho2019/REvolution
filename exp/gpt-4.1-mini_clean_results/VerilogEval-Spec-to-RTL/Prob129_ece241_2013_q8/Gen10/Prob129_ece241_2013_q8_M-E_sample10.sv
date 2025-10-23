module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding
    localparam S0 = 3'b001; // initial state, no match yet
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        next_state = 3'b000; // default to invalid to catch errors if any

        case(state)
            S0: begin
                if (x)
                    next_state = S1;  // detected '1', go to S1
                else
                    next_state = S0;  // stay in S0 if '0'
            end

            S1: begin
                if (x)
                    next_state = S1;  // '1' after '1', remain in S1 (overlapping)
                else
                    next_state = S2;  // '0' after '1', matched "10"
            end

            S2: begin
                if (x)
                    next_state = S1;  // '1' after "10", sequence "101" detected, restart with S1
                else
                    next_state = S0;  // '0' after "10", reset to initial state
            end

            default: next_state = S0; // safe default for robustness
        endcase
    end

    // Mealy output logic: assert z when the next input x completes the "101" sequence
    // This happens when in S2 and input x=1
    always @(*) begin
        z = (state == S2) && (x == 1'b1);
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule