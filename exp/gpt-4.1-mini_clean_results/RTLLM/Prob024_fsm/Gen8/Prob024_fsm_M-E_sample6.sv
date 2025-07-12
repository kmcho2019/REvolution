module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding
    localparam S0 = 6'b000001; // Initial state, no input matched
    localparam S1 = 6'b000010; // matched '1'
    localparam S2 = 6'b000100; // matched '10'
    localparam S3 = 6'b001000; // matched '100'
    localparam S4 = 6'b010000; // matched '1001'
    localparam S5 = 6'b100000; // matched '10011' (final match state)

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        MATCH = 1'b0; // default output

        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay if input '1' (allow overlapping)
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
                if (IN == 1'b1) begin
                    next_state = S5;
                    MATCH = 1'b1; // Mealy output asserted at final correct input
                end
                else
                    next_state = S2; // loops back to matched '10'
            end

            S5: begin
                // After detecting full sequence '10011', loop back to allow overlapping detection
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
                MATCH = 1'b0; // MATCH only asserted on final input=1 at S4, not here
            end

            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

endmodule