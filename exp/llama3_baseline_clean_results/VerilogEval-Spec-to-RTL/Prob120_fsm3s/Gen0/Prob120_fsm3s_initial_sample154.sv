module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // default to A if unknown state
    endcase
end

// Output logic (Moore machine, output depends only on state)
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // default to 0 if unknown state
    endcase
end

endmodule