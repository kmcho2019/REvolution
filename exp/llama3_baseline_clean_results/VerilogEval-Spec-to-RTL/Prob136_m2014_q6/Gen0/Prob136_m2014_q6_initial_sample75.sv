module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Determine the next state
always_comb begin
    case (state)
        A: next_state = (w)? A : B;
        B: next_state = (w)? D : C;
        C: next_state = (w)? D : E;
        D: next_state = (w)? A : F;
        E: next_state = (w)? D : E;
        F: next_state = (w)? D : C;
        default: next_state = A;
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine the output z
always_comb begin
    case (state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule