module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic for Mealy FSM detecting "10011"
    always @(*) begin
        // default assignments
        next_state = S0;
        MATCH = 1'b0;

        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1; // got first '1'
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2; // matched "10"
                else
                    next_state = S1; // consecutive '1's keep matching first bit
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3; // matched "100"
                else
                    next_state = S1; // restart matching from '1'
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4; // matched "1001"
                else
                    next_state = S0; // reset on mismatch
            end
            S4: begin
                if (IN == 1'b1) begin
                    // sequence "10011" matched here
                    MATCH = 1'b1;
                    next_state = S1; // allow overlap start
                end else if (IN == 1'b0) begin
                    // partial overlap for next sequence
                    MATCH = 1'b0;
                    next_state = S2; // matched '10' again
                end else begin
                    next_state = S0;
                    MATCH = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
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