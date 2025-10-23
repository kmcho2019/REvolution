module TopModule (
    input clk,
    input areset,
    input in,
    output logic out
);

// Define states
typedef enum logic [1:0] { A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11 } state_t;
state_t currentState, nextState;

// Combinational logic for next state
always_comb begin
    case (currentState)
        A: nextState = (in)? B : A;
        B: nextState = (in)? B : C;
        C: nextState = (in)? D : A;
        D: nextState = (in)? B : C;
        default: nextState = A;
    endcase
end

// Continuous assignment for output
always_comb begin
    case (currentState)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic for current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule