module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as an enumerated type
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinatorial logic for next state and output
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
    out = (state == D) ? 1'b1 : 1'b0;
end

endmodule