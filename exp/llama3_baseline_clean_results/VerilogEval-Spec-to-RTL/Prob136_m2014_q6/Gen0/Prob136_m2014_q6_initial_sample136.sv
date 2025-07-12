module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// Define the states of the state machine
parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize the current state
initial current_state = A;

// Combinational logic for next state
always @(*)
begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic for current state
always @(posedge clk or posedge reset)
begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output logic for z
assign z = (current_state == E) || (current_state == F);

endmodule