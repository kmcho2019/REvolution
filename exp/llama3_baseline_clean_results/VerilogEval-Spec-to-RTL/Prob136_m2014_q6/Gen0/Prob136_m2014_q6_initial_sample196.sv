module TopModule (
    input clk,
    input reset,
    input w,
    output logic z
);

// Define the states
typedef enum logic [3:0] {
    A = 4'b0001,
    B = 4'b0010,
    C = 4'b0011,
    D = 4'b0100,
    E = 4'b0101,
    F = 4'b0110
} state_type;

// Declare the current and next states
state_type current_state, next_state;

// Determine the next state
always_comb begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Determine the output z
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

// Update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule