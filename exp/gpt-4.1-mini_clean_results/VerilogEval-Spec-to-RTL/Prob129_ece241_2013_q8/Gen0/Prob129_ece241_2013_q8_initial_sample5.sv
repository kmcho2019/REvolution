module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // initial state, no bits matched
        S1 = 2'b01, // matched '1'
        S2 = 2'b10  // matched "10"
    } state_t;

    state_t state, next_state;

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic and output logic (Mealy)
    always @(*) begin
        z = 1'b0; // default output
        case (state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // still waiting for 0 in "101", stay in S1 if x=1
            end
            S2: begin
                if (x == 1'b1) begin
                    next_state = S1; // overlapping sequence: last '1' counted as start of next seq
                    z = 1'b1;        // sequence "101" detected
                end
                else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule