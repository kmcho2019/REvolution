module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary, 3 bits for 6 states)
    localparam [2:0]
        S0 = 3'd0,   // No bits matched
        S1 = 3'd1,   // Matched '1'
        S2 = 3'd2,   // Matched '10'
        S3 = 3'd3,   // Matched '100'
        S4 = 3'd4,   // Matched '1001'
        S5 = 3'd5;   // Matched '10011' (final)

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S2;
            end
            S5: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
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

    // MATCH output registered on clock, asserted when state transitions to S5,
    // i.e., the last input bit '1' completes sequence "10011"
    // This registers MATCH one cycle after detection for glitch-free output and power optimization.
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            MATCH <= (state == S4) && (IN == 1'b1);
    end

endmodule