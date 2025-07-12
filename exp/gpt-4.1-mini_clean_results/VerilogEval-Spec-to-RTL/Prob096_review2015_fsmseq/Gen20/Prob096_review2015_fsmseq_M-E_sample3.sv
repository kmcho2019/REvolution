module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // Binary encoding of states
    localparam [2:0]
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // detected full sequence "1101"

    reg [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // start_shifting latch logic:
            // Once asserted (in detected state or on detection), stays high forever until reset
            if (state == S4)
                start_shifting <= 1'b1;
            else if (next_state == S4)
                start_shifting <= 1'b1;
            // else keep previous value (do not clear start_shifting)
        end
    end

    // Next state logic and Mealy output generation
    always @(*) begin
        next_state = S0; // default next state
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // stay detected
            default: next_state = S0;
        endcase
    end

endmodule