module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states of the FSM
enum logic [2:0] {S4, S5, S6, S0} current_state, next_state;

// Combinational logic for next state calculation
always @(*) begin
    case (current_state)
        S4: if (a) next_state = S4; else next_state = S5;
        S5: if (a) next_state = S4; else next_state = S6;
        S6: if (a) next_state = S4; else next_state = S0;
        S0: if (a) next_state = S4; else next_state = S4;
        default: next_state = S4;
    endcase
end

// Sequential logic to update the current state
always @(posedge clk) begin
    current_state <= next_state;
end

// Output logic
always @(*) begin
    case (current_state)
        S4: q = 4;
        S5: q = 5;
        S6: q = 6;
        S0: q = 0;
        default: q = 4;
    endcase
end

// Initialize the current state
initial current_state = S4;

endmodule