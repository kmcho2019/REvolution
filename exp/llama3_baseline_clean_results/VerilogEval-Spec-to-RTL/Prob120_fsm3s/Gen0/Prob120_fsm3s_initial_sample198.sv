module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

state_t current_state;
state_t next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A; // Default to state A in case of unknown state
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0 in case of unknown state
    endcase
end

endmodule