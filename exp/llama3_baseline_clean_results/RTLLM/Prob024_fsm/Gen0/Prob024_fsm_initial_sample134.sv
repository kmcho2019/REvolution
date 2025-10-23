module fsm(
    input  logic IN,
    input  logic CLK,
    input  logic RST,
    output logic MATCH
);

enum logic [2:0] {
    S0, // Initial state
    S1, // After seeing '1'
    S2, // After seeing '10'
    S3, // After seeing '100'
    S4, // After seeing '1001'
    S5  // After seeing '10011', match state
} state, next_state;

always_comb begin
    next_state = state;
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
            else next_state = S2;
        end
        S4: begin
            if (IN) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN) next_state = S1; // Loop back to start of sequence if input continues with '1'
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
        case (state)
            S5: MATCH <= 1;
            default: MATCH <= 0;
        endcase
    end
end

endmodule