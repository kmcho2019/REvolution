module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoded states: only one bit set per state
    // S0: no match yet
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    typedef enum reg [4:0] {
        S0 = 5'b00001,
        S1 = 5'b00010,
        S2 = 5'b00100,
        S3 = 5'b01000,
        S4 = 5'b10000
    } state_t;

    state_t state, next_state;

    // Next state combinational logic based on current state and input
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;

            S1: next_state = (IN) ? S1 : S2;

            S2: next_state = (IN) ? S1 : S3;

            S3: next_state = (IN) ? S4 : S0;

            S4: next_state = (IN) ? S1 : S2;

            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // Registered MATCH output asserted 1 cycle after detecting last input bit
            // Sequence detected when current state is S4 and input IN=1 (last bit),
            // but we register MATCH for stable output in next cycle.
            MATCH <= (state == S4) && (IN == 1'b1);
        end
    end

endmodule