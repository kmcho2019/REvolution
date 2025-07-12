module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic and output computation
    always @(*) begin
        MATCH = 1'b0;
        case (state)
            S0: if (IN)       next_state = S1; else next_state = S0;
            S1: if (~IN)      next_state = S2; else next_state = S1;
            S2: if (~IN)      next_state = S3; else next_state = S1;
            S3: if (IN)       next_state = S4; else next_state = S0;
            S4: begin
                MATCH = IN; // Output 1 if IN=1 at final state to match "10011"
                if (IN)
                    next_state = S1; // New sequence may start
                else
                    next_state = S2; // Partial overlap
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

endmodule