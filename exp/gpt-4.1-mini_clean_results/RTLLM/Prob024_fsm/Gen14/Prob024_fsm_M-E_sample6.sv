module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot states (6 states)
    localparam S0 = 6'b000001; // initial state
    localparam S1 = 6'b000010; // matched '1'
    localparam S2 = 6'b000100; // matched '10'
    localparam S3 = 6'b001000; // matched '100'
    localparam S4 = 6'b010000; // matched '1001'
    localparam S5 = 6'b100000; // matched '10011' final (transient)

    reg [5:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        next_state = 6'b000000; // default no state (should not happen)

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
                else // IN==1
                    next_state = S1; // still matched '1'
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN==1
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else // IN==0
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1)
                    next_state = S5; // final matched
                else // IN==0
                    next_state = S2; // partial match for overlapping detection
            end

            S5: begin
                // After detecting full sequence, reset to proper state for overlap
                // Since last input was '1', we check input again to decide:
                // But IN is only updated once per cycle, so next state depends only on IN at next cycle
                // Here, just treat as transition state to next appropriate state
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
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

    // Mealy output: MATCH asserted combinationally
    // MATCH is high only on transition from S4 with IN=1 (when moving to S5)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule