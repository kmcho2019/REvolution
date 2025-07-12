module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Next state logic
always_comb begin
    case (state)
        A: next_state = (in == 0)? A : B;
        B: next_state = (in == 0)? C : B;
        C: next_state = (in == 0)? A : D;
        D: next_state = (in == 0)? C : B;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule