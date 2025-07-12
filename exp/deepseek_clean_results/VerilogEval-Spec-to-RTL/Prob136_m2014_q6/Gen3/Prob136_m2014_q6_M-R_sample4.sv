module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// One-hot state encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

reg [5:0] state, next_state;

// Combinational next state logic
always @(*) begin
    case (1'b1) // synthesis parallel_case
        state[A]: next_state = w ? A : B;
        state[B]: next_state = w ? D : C;
        state[C]: next_state = w ? D : E;
        state[D]: next_state = w ? A : F;
        state[E]: next_state = w ? D : E;
        state[F]: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Sequential state update
always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Output logic
assign z = state[E] | state[F];

endmodule