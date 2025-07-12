module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} currentState, nextState;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic for next state
always_comb begin
    case (currentState)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
    endcase
end

// Output logic
assign out = (currentState == D) ? 1'b1 : 1'b0;

endmodule