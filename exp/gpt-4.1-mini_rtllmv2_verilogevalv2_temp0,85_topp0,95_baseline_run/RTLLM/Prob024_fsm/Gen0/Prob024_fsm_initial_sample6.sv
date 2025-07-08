module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            S0: begin
                if (IN == 1'b1)      next_state = S1;
                else                 next_state = S0;
            end

            S1: begin
                if (IN == 1'b0)      next_state = S2;
                else                 next_state = S1; // sequence start again if IN=1
            end

            S2: begin
                if (IN == 1'b0)      next_state = S3;
                else                 next_state = S1; // restart from first 1
            end

            S3: begin
                if (IN == 1'b1)      next_state = S4;
                else                 next_state = S0;
            end

            S4: begin
                if (IN == 1'b1)      next_state = S1; // sequence matched, next can start new with 1
                else                 next_state = S2; // got 0 after '1001' -> partial match '10'
            end

            default: next_state = S0;
        endcase
    end

    // Output logic and state update (sequential)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH = 1 only when we transition into S4 and input=1 (last bit of sequence)
            // But in Mealy machine, output depends on current state and input.
            // Here, MATCH is 1 only if current state is S4 and input IN=1 (the last matched bit)
            // Actually, since MATCH must be 1 at the cycle the last input is seen,
            // we check if next_state == S4 and input IN == 1 at this cycle.
            MATCH <= (next_state == S4 && IN == 1'b1) ? 1'b1 : 1'b0;
        end
    end

endmodule