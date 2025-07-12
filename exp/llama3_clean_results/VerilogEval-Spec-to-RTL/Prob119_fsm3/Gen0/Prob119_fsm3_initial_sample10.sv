module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] { A, B, C, D } currentState, nextState;

// Combinational logic for next state
always_comb begin
    case (currentState)
        A: nextState = (in) ? B : A;
        B: nextState = (in) ? B : C;
        C: nextState = (in) ? D : A;
        D: nextState = (in) ? B : C;
        default: nextState = A;
    endcase
end

// Sequential logic for current state and output
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
        out <= 0;
    end else begin
        currentState <= nextState;
        case (currentState)
            A, B, C: out <= 0;
            D: out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule