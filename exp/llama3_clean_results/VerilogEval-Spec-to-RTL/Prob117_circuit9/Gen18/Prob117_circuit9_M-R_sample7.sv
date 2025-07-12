module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states of the FSM
enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} state, next_state;

// Initialize the state
initial state = S4;

// Define the state transition logic
always @(posedge clk) begin
    state <= next_state;
end

// Define the next state logic
always @(*) begin
    case (state)
        S0: next_state = a ? S4 : S1;
        S1: next_state = a ? S4 : S2;
        S2: next_state = a ? S4 : S3;
        S3: next_state = a ? S4 : S4;
        S4: next_state = a ? S4 : S5;
        S5: next_state = a ? S4 : S6;
        S6: next_state = a ? S4 : S0;
        default: next_state = S4;
    endcase
end

// Define the output logic
always @(*) begin
    case (state)
        S0: q = 0;
        S1: q = 1;
        S2: q = 2;
        S3: q = 3;
        S4: q = 4;
        S5: q = 5;
        S6: q = 6;
        default: q = 4;
    endcase
end

endmodule