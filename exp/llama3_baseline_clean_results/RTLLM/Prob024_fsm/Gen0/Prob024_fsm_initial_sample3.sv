module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Initialize MATCH to 0
assign MATCH = (state == S4) && IN;

// State transition logic
always_comb begin
    case (state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S2;
        S3: next_state = IN ? S4 : S0;
        S4: next_state = IN ? S4 : S0;
        default: next_state = S0;
    endcase
end

// State register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

endmodule