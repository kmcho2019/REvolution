module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding for sequence "10011"
    localparam S0 = 3'b000; // no bits matched
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '10'
    localparam S3 = 3'b011; // matched '100'
    localparam S4 = 3'b100; // matched '1001'

    reg [2:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is Mealy output: depends on current state and current input
            // MATCH = 1 only when in S4 and IN == 1, completing "10011"
            MATCH <= (state == S4) && (IN == 1'b1);
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            S0: begin
                // from idle, if IN=1 start sequence else stay idle
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // matched '1'
                if (IN == 1'b0)
                    next_state = S2; // matched '10'
                else
                    next_state = S1; // still matched '1', possible restart
            end

            S2: begin
                // matched '10'
                if (IN == 1'b0)
                    next_state = S3; // matched '100'
                else
                    next_state = S1; // restart from '1'
            end

            S3: begin
                // matched '100'
                if (IN == 1'b1)
                    next_state = S4; // matched '1001'
                else
                    next_state = S0; // mismatch, back to idle
            end

            S4: begin
                // matched '1001'
                if (IN == 1'b1)
                    next_state = S1; // full sequence complete, restart from '1'
                else
                    next_state = S2; // if '0' next matched '10'
            end

            default: next_state = S0;
        endcase
    end

endmodule