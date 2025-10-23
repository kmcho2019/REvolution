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
    S4 = 3'b100,
    S5 = 3'b101
} state, next_state;

// State transition logic
always_comb begin
    case (state)
        S0: begin
            if (IN == 1'b1) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (IN == 1'b0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (IN == 1'b0) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN == 1'b1) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (IN == 1'b1) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic
assign MATCH = (state == S5) && (IN == 1'b1);

// State register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= S0;
    else state <= next_state;
end

endmodule