module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states using an enum
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} currentState, nextState;

// Combinational always block to determine next state
always_comb begin
    case(currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A; // In case of invalid state
    endcase
end

// Combinational always block to determine output
always_comb begin
    case(currentState)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // In case of invalid state
    endcase
end

// Sequential always block to handle state transition and reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule