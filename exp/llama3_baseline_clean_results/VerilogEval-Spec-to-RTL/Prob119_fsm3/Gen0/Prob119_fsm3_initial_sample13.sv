module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// State transition logic
always_comb begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A;
    endcase
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule