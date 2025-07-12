module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using a more compact encoding scheme
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// Output z is 1 when the state machine is in state E or F
assign z = (currentState == E) || (currentState == F);

// State transition logic using a more efficient encoding scheme
always_comb begin
    case (currentState)
        A: nextState = w? A : B;
        B: nextState = w? D : C;
        C: nextState = w? D : E;
        D: nextState = w? A : F;
        E: nextState = w? D : E;
        F: nextState = w? D : C;
        default: nextState = A;
    endcase
end

// Sequential logic using clock gating to minimize unnecessary transitions
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule