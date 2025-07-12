module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {A, B, C, D} state_t;
state_t current_state, next_state;

// State transition logic
always_comb begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Sequential logic with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule