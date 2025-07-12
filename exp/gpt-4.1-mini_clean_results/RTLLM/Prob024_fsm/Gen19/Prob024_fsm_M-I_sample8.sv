module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary, 3 bits)
    localparam S0 = 3'b000; // no bits matched
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '10'
    localparam S3 = 3'b011; // matched '100'
    localparam S4 = 3'b100; // matched '1001'

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic - case statement for clarity and synthesis optimization
    always @(*) begin
        case(state)
            S0: begin
                // From idle: if IN==1 start pattern, else stay idle
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1'
                if (IN == 1'b0)
                    next_state = S2;  // '10'
                else
                    next_state = S1;  // '1' again (overlap)
            end

            S2: begin
                // Matched '10'
                if (IN == 1'b0)
                    next_state = S3;  // '100'
                else
                    next_state = S1;  // restart with '1' for overlap
            end

            S3: begin
                // Matched '100'
                if (IN == 1'b1)
                    next_state = S4;  // '1001'
                else
                    next_state = S0;  // break pattern
            end

            S4: begin
                // Matched '1001'
                if (IN == 1'b1)
                    next_state = S1;  // '10011' matched on this input, restart for overlap
                else
                    next_state = S2;  // partial suffix matched '10'
            end

            default: next_state = S0;
        endcase
    end

    // MATCH output: Mealy output asserted when current state is S4 and IN==1,
    // indicating full sequence "10011" matched at this clock cycle.
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule