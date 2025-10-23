module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enumerate the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(state) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(state, in) begin
    case (state)
        A: if (!in) next_state = A; else next_state = B;
        B: if (!in) next_state = C; else next_state = B;
        C: if (!in) next_state = A; else next_state = D;
        D: if (!in) next_state = C; else next_state = B;
        default: next_state = A;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule