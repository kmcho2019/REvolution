module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enumeration
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Assign output z based on the current state
always @(*) begin
    case (state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Determine the next state based on the current state and input
always @(*) begin
    case (state)
        A: if (w == 1) next_state = A; else next_state = B;
        B: if (w == 1) next_state = D; else next_state = C;
        C: if (w == 1) next_state = D; else next_state = E;
        D: if (w == 1) next_state = A; else next_state = F;
        E: if (w == 1) next_state = D; else next_state = E;
        F: if (w == 1) next_state = D; else next_state = C;
        default: next_state = A;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule