module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic w,
    output logic z
);

// Define states using enum
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state register
state_t current_state;
state_t next_state;

// Output logic
always_comb begin
    case (current_state)
        A, B, C, D: z = 1'b0;
        E, F: z = 1'b1;
        default: z = 1'bx; // Handle default case to avoid lint warnings
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= (w) ? A : B;
            B: current_state <= (w) ? D : C;
            C: current_state <= (w) ? D : E;
            D: current_state <= (w) ? A : F;
            E: current_state <= (w) ? D : E;
            F: current_state <= (w) ? D : C;
            default: current_state <= A; // Handle default case to avoid lint warnings
        endcase
    end
end

endmodule