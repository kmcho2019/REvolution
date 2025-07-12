module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// One-hot state encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

reg [5:0] current_state, next_state;
wire common_transition = w ? D : 6'b0;  // Common transition pattern

// Sequential state storage with synchronous reset
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Combinational next-state logic with factored common terms
always @(*) begin
    case (1'b1)  // One-hot style case statement
        current_state[A]: next_state = w ? A : B;
        current_state[B]: next_state = w ? D : C;
        current_state[C]: next_state = w ? D : E;
        current_state[D]: next_state = w ? A : F;
        current_state[E]: next_state = w ? D : E;
        current_state[F]: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Registered output for clean timing and reduced glitching
always @(posedge clk) begin
    if (reset)
        z <= 1'b0;
    else
        z <= (next_state == E) | (next_state == F);
end

endmodule