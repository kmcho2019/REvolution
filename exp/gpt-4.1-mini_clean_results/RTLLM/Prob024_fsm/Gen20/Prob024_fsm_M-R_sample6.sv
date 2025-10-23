module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'b000, // no bits matched
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched '10'
        S3 = 3'b011, // matched '100'
        S4 = 3'b100; // matched '1001'

    reg [2:0] state, next_state;

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state and MATCH output logic
    reg match_reg;
    always @(*) begin
        // Default assignments
        next_state = S0;
        match_reg = 1'b0;

        case (state)
            S0: begin
                // If IN==1, start matching sequence
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1'
                if (IN == 1'b0)
                    next_state = S2; // matched '10'
                else
                    next_state = S1; // still '1' (possible restart)
            end

            S2: begin
                // Matched '10'
                if (IN == 1'b0)
                    next_state = S3; // matched '100'
                else
                    next_state = S1; // restart from '1'
            end

            S3: begin
                // Matched '100'
                if (IN == 1'b1)
                    next_state = S4; // matched '1001'
                else
                    next_state = S0; // mismatch
            end

            S4: begin
                // Matched '1001'
                if (IN == 1'b1) begin
                    // Full sequence "10011" matched here
                    match_reg = 1'b1;
                    next_state = S1; // overlapping sequences start from here
                end else begin
                    // IN == 0, move to matched '10' state (S2) for overlap
                    next_state = S2;
                end
            end

            default: begin
                next_state = S0;
                match_reg = 1'b0;
            end
        endcase
    end

    assign MATCH = match_reg;

endmodule