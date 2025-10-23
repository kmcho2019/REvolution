module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState;

// Output z is 1 when the state machine is in state E or F
assign z = (currentState == E) || (currentState == F);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        case (currentState)
            A: currentState <= w? A : B;
            B: currentState <= w? D : C;
            C: currentState <= w? D : E;
            D: currentState <= w? A : F;
            E: currentState <= w? D : E;
            F: currentState <= w? D : C;
            default: currentState <= A;
        endcase
    end
end

endmodule