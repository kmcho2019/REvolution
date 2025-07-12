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
always @(*)
begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'bx;
    endcase
end

// Determine the next state based on the current state and input
always @(*)
begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = 2'bx;
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        current_state <= A;
    end
    else
    begin
        current_state <= next_state;
    end
end

endmodule