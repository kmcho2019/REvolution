module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Enum for states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} current_state, next_state;

// Combinational logic for next state
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Sequential logic for state register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule