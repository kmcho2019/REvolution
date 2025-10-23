module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define the states
enum logic [1:0] {
    A,
    B,
    C,
    D
} state, next_state;

// State transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
    // Output logic
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule