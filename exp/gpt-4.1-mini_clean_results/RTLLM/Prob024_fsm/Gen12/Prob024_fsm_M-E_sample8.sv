module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding for 6 states
    localparam S0 = 6'b000001; // initial state, no match yet
    localparam S1 = 6'b000010; // detected '1'
    localparam S2 = 6'b000100; // detected '10'
    localparam S3 = 6'b001000; // detected '100'
    localparam S4 = 6'b010000; // detected '1001'
    localparam S5 = 6'b100000; // detected '10011' (final)

    reg [5:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        // Default next state is S0
        next_state = S0;
        MATCH = 1'b0; // Default MATCH = 0

        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (~IN)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (~IN)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                if (IN)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                if (IN) begin
                    next_state = S5;
                    MATCH = 1'b1; // Match detected at input 1 completing "10011"
                end else
                    next_state = S2; // Partial overlap detection
            end

            S5: begin
                // After detecting full sequence "10011", look for next partial sequence
                if (IN)
                    next_state = S1;
                else
                    next_state = S2;
                MATCH = 1'b1; // Output MATCH is also 1 at this cycle for final state and IN=1
            end

            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

endmodule