module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as 2-bit values
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state signals
reg [1:0] currentState, nextState;

// Output is determined by current state
always @(*)
    case (currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase

// Next state logic
always @(*)
    case (currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
    endcase

// State register
always @(posedge clk or posedge reset)
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end

endmodule