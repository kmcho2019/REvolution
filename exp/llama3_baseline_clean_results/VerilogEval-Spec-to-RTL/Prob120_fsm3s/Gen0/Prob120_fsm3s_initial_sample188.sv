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
} state, nextState;

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always_comb begin
    case (state)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A;
    endcase
end

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule