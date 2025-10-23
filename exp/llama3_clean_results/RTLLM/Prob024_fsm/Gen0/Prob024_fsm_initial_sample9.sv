module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    S0 = 3'b000, // Initial state
    S1 = 3'b001, // Detected '1'
    S2 = 3'b010, // Detected '10'
    S3 = 3'b011, // Detected '100'
    S4 = 3'b100, // Detected '1001'
    S5 = 3'b101  // Detected '10011'
} state, next_state;

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    case (state)
        S0: if (IN) next_state = S1; else next_state = S0;
        S1: if (!IN) next_state = S2; else next_state = S1;
        S2: if (!IN) next_state = S3; else next_state = S1;
        S3: if (IN) next_state = S4; else next_state = S1;
        S4: if (IN) next_state = S5; else next_state = S1;
        S5: if (IN) next_state = S5; else next_state = S1;
        default: next_state = S0;
    endcase
end

// Sequential logic for state update and output
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
        MATCH <= (state == S5 && IN);
    end
end

endmodule