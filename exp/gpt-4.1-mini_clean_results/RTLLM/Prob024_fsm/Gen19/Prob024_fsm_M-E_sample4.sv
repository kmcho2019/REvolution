module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoded states for better clarity and performance
    localparam S0 = 5'b00001; // Initial state, no matched bits
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '10'
    localparam S3 = 5'b01000; // matched '100'
    localparam S4 = 5'b10000; // matched '1001'

    reg [4:0] state, next_state;

    // State register
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy output)
    always @(*) begin
        // Default assignments
        next_state = S0;
        MATCH = 1'b0;

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
                    // Stay in S1 if input is '1' (could be start of new sequence)
                    next_state = S1;
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    // Overlap fallback: input is '1', which matches S1 state prefix
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    // No valid prefix on mismatch, go to initial
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1) begin
                    // Pattern "10011" matched at this input
                    MATCH = 1'b1;
                    // Overlap fallback after match:
                    // Input '1' also matches prefix start, go to S1
                    next_state = S1;
                end else begin
                    // Input is '0', fallback to S2 which corresponds to '10' prefix
                    next_state = S2;
                    MATCH = 1'b0;
                end
            end

            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

endmodule