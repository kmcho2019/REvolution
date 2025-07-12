module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

enum logic [2:0] {S0, S1, S2, S3, S4, S5} state, next_state;

always_comb begin
    case (state)
        S0: next_state = (IN) ? S1 : S0;
        S1: next_state = (IN) ? S1 : S2;
        S2: next_state = (IN) ? S3 : (IN == 1'b0) ? S2 : S2;
        S3: next_state = (IN) ? S4 : S0;
        S4: next_state = (IN) ? S5 : S0;
        S5: next_state = S0;
        default: next_state = S0;
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= (state == S5) ? 1'b1 : 1'b0;
    end
end

endmodule