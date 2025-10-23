module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

typedef enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101
} state_t;

state_t state, next_state;

always_comb begin
    case (state)
        S0: next_state = (IN == 1'b1)? S1 : S0;
        S1: next_state = (IN == 1'b0)? S2 : S0;
        S2: next_state = (IN == 1'b0)? S3 : S0;
        S3: next_state = (IN == 1'b1)? S4 : S0;
        S4: next_state = (IN == 1'b1)? S5 : S0;
        S5: next_state = (IN == 1'b1)? S5 : S0;
        default: next_state = S0;
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            S5: MATCH <= 1'b1;
            default: MATCH <= 1'b0;
        endcase
    end
end

endmodule