module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as parameters
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Current state and next state
reg [1:0] current_state, next_state;

// Initialize current state to A
initial current_state = A;

// Combinational logic to determine next state
always @(*)
begin
    case(current_state)
        A: if (!in) next_state = A; else next_state = B;
        B: if (!in) next_state = C; else next_state = B;
        C: if (!in) next_state = A; else next_state = D;
        D: if (!in) next_state = C; else next_state = B;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state and output
always @(posedge clk)
begin
    if (reset) 
    begin
        current_state <= A;
    end
    else
    begin
        current_state <= next_state;
    end
end

// Output logic
assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule