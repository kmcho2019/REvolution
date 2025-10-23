module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enumerate the states for simplicity
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the current and next states
reg [1:0] current_state, next_state;

// Output logic based on the current state
assign out = (current_state == D) ? 1'b1 : 1'b0;

// Next state logic based on the given state transition table
always @(*)
begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A; // Handle any unexpected states
    endcase
end

// Sequential logic triggered on the positive edge of the clock
always @(posedge clk or posedge reset)
begin
    if (reset)
        current_state <= A; // Reset to state A on active high reset
    else
        current_state <= next_state; // Update current state based on next state
end

endmodule