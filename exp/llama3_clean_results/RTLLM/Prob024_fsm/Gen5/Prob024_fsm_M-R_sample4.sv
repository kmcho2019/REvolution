module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101
} state_type;

reg state_type state;
reg state_type next_state;

// Combinational logic for next state
always @(*) begin
    case(state)
        S0: if(IN) next_state = S1; else next_state = S0;
        S1: if(!IN) next_state = S2; else next_state = S1;
        S2: if(!IN) next_state = S3; else next_state = S1;
        S3: if(IN) next_state = S4; else next_state = S3;
        S4: if(IN) next_state = S5; else next_state = S2;
        S5: if(IN) next_state = S5; else next_state = S2;
        default: next_state = S0;
    endcase
end

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state = S0;
        MATCH = 1'b0;
    end else begin
        state = next_state;
        MATCH = (state == S5 && IN);
    end
end

endmodule