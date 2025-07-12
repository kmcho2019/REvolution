module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state
reg state_t current_state;

// Next state
state_t next_state;

// Initialize the current state to A
initial begin
    current_state = A;
end

// Update the current state on each positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (current_state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
        default: next_state = A;
    endcase
end

// Determine the output z based on the current state
always @(*) begin
    case (current_state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule