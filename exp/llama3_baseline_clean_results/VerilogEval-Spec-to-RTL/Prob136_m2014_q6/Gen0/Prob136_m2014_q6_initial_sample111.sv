module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enum
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Initialize the state to A
initial state = A;

// Determine the next state based on the current state and input
always @(*) begin
    case(state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine the output z based on the current state
always @(state) begin
    case(state)
        A, B: z = 0;
        C, D, E, F: z = state[2];
        default: z = 0;
    endcase
end

endmodule