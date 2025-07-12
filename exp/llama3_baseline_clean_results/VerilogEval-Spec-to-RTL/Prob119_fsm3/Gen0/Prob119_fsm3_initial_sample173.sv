module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states as an enumeration
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// Combinational logic to determine next state and output
always_comb begin
    case (state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
            out = 0;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 0;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
            out = 0;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

// Sequential logic to update state on positive edge of clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= A; // Asynchronous reset
    else state <= next_state;
end

endmodule