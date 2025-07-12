module TopModule (
    input clk,
    input reset,
    input w,
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

// Current state register
reg [2:0] current_state;

// Initialize the current state to A on reset
initial current_state = A;

// Handle state transitions on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Determine the next state based on the current state and input w
always @(*) begin
    case (current_state)
        A: next_state = (w == 1'b1) ? A : B;
        B: next_state = (w == 1'b1) ? D : C;
        C: next_state = (w == 1'b1) ? D : E;
        D: next_state = (w == 1'b1) ? A : F;
        E: next_state = (w == 1'b0) ? E : D;
        F: next_state = (w == 1'b0) ? C : D;
        default: next_state = A;
    endcase
end

// Determine the output z based on the current state
always @(*) begin
    case (current_state)
        A, B, C, D: z = 1'b0;
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule