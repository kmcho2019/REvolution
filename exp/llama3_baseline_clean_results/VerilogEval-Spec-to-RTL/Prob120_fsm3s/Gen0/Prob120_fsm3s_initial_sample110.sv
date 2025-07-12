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
} state_type;

// Current state and next state registers
state_type current_state, next_state;

// Output logic
always_comb begin
    case(current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always_comb begin
    case(current_state)
        A: if (~in) next_state = A;
           else next_state = B;
        B: if (~in) next_state = C;
           else next_state = B;
        C: if (~in) next_state = A;
           else next_state = D;
        D: if (~in) next_state = C;
           else next_state = B;
        default: next_state = A;
    endcase
end

// State register with reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule