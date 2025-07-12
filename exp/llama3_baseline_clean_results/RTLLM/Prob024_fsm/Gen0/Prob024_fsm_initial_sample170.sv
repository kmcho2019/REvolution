module fsm (
    input  logic IN, 
    input  logic CLK, 
    input  logic RST, 
    output logic MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    S0,  // Initial state
    S1,  // State after receiving the first 1
    S2,  // State after receiving the first 0
    S3,  // State after receiving the second 0
    S4,  // State after receiving the first 1 in the second sequence
    S5   // State after receiving the second 1
} state, next_state;

// Output logic
always_comb begin
    case (state)
        S0: MATCH = 0;
        S1: MATCH = 0;
        S2: MATCH = 0;
        S3: MATCH = 0;
        S4: MATCH = 0;
        S5: MATCH = 1;
        default: MATCH = 0;
    endcase
end

// Next state logic
always_comb begin
    case (state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S3;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// State register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= S0;
    else state <= next_state;
end

endmodule