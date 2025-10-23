module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using one-hot encoding
typedef enum logic [4:0] {
    S0 = 5'b00001, S1 = 5'b00010, S2 = 5'b00100, S3 = 5'b01000, S4 = 5'b10000
} state_type;

reg state_type state;
reg state_type next_state;

// Combinational logic for next state
always_comb begin
    case(state)
        S0: if(IN) next_state = S1; else next_state = S0;
        S1: if(!IN) next_state = S2; else next_state = S1;
        S2: if(!IN) next_state = S3; else next_state = S1;
        S3: if(IN) next_state = S4; else next_state = S3;
        S4: if(IN) next_state = S4; else next_state = S2;
        default: next_state = S0;
    endcase
end

// Sequential logic for state update and output
always_ff @(posedge CLK or posedge RST) begin
    if(RST) begin
        state = S0;
        MATCH = 1'b0;
    end else begin
        state = next_state;
        MATCH = (state == S4 && IN);
    end
end

endmodule