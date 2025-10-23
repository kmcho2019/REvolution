module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states as an enumerated type
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_type;

// Declare the current state and the next state
state_type current_state, next_state;

// Output z is determined by the current state
always_comb begin
    case (current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Determine the next state based on the current state and input w
always_comb begin
    case (current_state)
        A: if (w) next_state = A; else next_state = B;
        B: if (w) next_state = D; else next_state = C;
        C: if (w) next_state = D; else next_state = E;
        D: if (w) next_state = A; else next_state = F;
        E: if (w) next_state = D; else next_state = E;
        F: if (w) next_state = D; else next_state = C;
        default: next_state = A;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule