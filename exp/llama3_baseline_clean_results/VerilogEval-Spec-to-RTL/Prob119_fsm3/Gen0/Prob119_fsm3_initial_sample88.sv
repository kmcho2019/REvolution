module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states as parameters for clarity
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*)
begin
    case(current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A; // Default state
    endcase
end

// Sequential logic to update the current state
always @(posedge clk or posedge areset)
begin
    if(areset)
        current_state <= A; // Reset to state A on async reset
    else
        current_state <= next_state; // Update state on posedge of clk
end

// Output logic based solely on the current state
always @(*)
begin
    case(current_state)
        A, B, C: out = 0; // Output 0 for states A, B, C
        D: out = 1; // Output 1 for state D
        default: out = 0; // Default output
    endcase
end

endmodule