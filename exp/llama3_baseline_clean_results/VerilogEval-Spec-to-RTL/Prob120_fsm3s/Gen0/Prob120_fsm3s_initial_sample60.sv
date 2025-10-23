module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic in,
    output logic out
);

// Define the states as an enum
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current and next state variables
state_t current_state, next_state;

// Output logic based on the current state
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default to 0 in case of invalid state
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A; // Default to A in case of invalid state
    endcase
end

// Sequential logic with reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule