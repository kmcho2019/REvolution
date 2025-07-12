module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state and next state
reg [1:0] currentState;
reg [1:0] nextState;

// Determine next state
always_comb begin
    case(currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A; // Default to state A
    endcase
end

// Update current state on positive edge of clock
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Assign output based on current state
always_comb begin
    case(currentState)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default to 0
    endcase
end

endmodule