module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {A, B, C, D} state, next_state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // This should never happen
    endcase
end

// Next state logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // This should never happen
    endcase
end

// State update logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule