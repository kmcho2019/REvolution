module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Enum for states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Assign output based on state
always_comb begin
    case(state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = w; // Note: E(1) --0--> E and E(1) --1--> D, so output z is 1 when w is 1 in state E
        F: z = w; // Note: F(1) --0--> C and F(1) --1--> D, so output z is 1 when w is 1 in state F
        default: z = 0;
    endcase
end

// State transitions
always_comb begin
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

// Update state on positive edge of clock
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule