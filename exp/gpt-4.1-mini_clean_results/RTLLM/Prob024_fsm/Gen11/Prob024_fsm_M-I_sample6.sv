module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Gray-coded states for reduced toggling:
    localparam [2:0]
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b011, // matched '10'
        S3 = 3'b010, // matched '100'
        S4 = 3'b110; // matched '1001'

    reg [2:0] state, next_state;
    reg       in_d; // delayed input for detecting changes

    // Combinational next state logic inside always_comb block for glitch reduction
    always @* begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S1 :
                              (IN == 1'b0) ? S2 : S0;
            default: next_state = S0;
        endcase
    end

    // Clock gating: enable only when IN changes or state changes
    wire enable = (IN != in_d) || (next_state != state);

    // State register update with synchronous reset and clock gating
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            in_d <= 1'b0;
        end else begin
            in_d <= IN;
            if (enable)
                state <= next_state;
        end
    end

    // Register MATCH output (Mealy output delayed by one cycle) to reduce glitching
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            // MATCH is high when previous state was S4 and current input IN=1
            // This corresponds to outputting MATCH 1 cycle after detecting full sequence,
            // trading latency for cleaner output and timing improvement
            MATCH <= (state == S4) && (IN == 1'b1);
    end

endmodule