module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Determine the output based on the current state
always @(current_state)
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase

// Determine the next state based on the current state and input 'in'
always @*
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset)
    if (areset)
        current_state <= A;
    else
        current_state <= next_state;

endmodule