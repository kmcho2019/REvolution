module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as enumerated constants
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

// Current state
state_type state;
state_type next_state;

// Combinational logic block to determine next state and output
always_comb begin
    case(state)
        A: begin
            if (~in) next_state = A;
            else     next_state = B;
            out      = 0;
        end
        B: begin
            if (~in) next_state = C;
            else     next_state = B;
            out      = 0;
        end
        C: begin
            if (~in) next_state = A;
            else     next_state = D;
            out      = 0;
        end
        D: begin
            if (~in) next_state = C;
            else     next_state = B;
            out      = 1;
        end
    endcase
end

// Sequential logic block to update current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= A;
    else         state <= next_state;
end

endmodule