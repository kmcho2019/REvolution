module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, nextState;

// Determine next state
always_comb begin
    case (state)
        A: nextState = (w) ? A : B;
        B: nextState = (w) ? D : C;
        C: nextState = (w) ? D : E;
        D: nextState = (w) ? A : F;
        E: nextState = (w) ? D : E;
        F: nextState = (w) ? D : C;
    endcase
end

// Update state on positive edge of clock
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Determine output z
always_comb begin
    case (state)
        A, B, C, D: z = 0;
        E, F: z = 1;
    endcase
end

endmodule