module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// Combinational logic for next state and output
always_comb begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
    endcase
end

// Sequential logic for state update and output
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            A: out <= 1'b0;
            B: out <= 1'b0;
            C: out <= 1'b0;
            D: out <= 1'b1;
        endcase
    end
end

endmodule