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

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state = S0;
        MATCH = 1'b0;
    end else begin
        case(state)
            S0: if(IN) state = S1; else state = S0;
            S1: if(!IN) state = S2; else state = S1;
            S2: if(!IN) state = S3; else state = S1;
            S3: if(IN) state = S4; else state = S3;
            S4: if(IN) state = S5; else state = S2;
            S5: if(IN) state = S5; else state = S2;
            default: state = S0;
        endcase
        MATCH = (state == S5 && IN);
    end
end

endmodule