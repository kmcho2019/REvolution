module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
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

// Combinational logic for next state
always_comb begin
    case (state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S1;
        S4: next_state = IN ? S5 : S1;
        S5: next_state = IN ? S5 : S1;
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