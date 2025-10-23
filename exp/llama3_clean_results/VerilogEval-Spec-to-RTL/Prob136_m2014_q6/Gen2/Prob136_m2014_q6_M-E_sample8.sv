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

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: next_state = (w == 1) ? A : B;
        B: next_state = (w == 1) ? D : C;
        C: next_state = (w == 1) ? D : E;
        D: next_state = (w == 1) ? A : F;
        E: next_state = (w == 1) ? D : E;
        F: next_state = (w == 1) ? D : C;
        default: next_state = A;
    endcase
end

// Combinational logic for output z
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

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule