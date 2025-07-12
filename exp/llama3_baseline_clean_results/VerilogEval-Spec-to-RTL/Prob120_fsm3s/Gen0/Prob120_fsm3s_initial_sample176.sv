module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as an enumeration
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Output logic based on the state
always_comb begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic based on the current state and input
always_comb begin
    case (state)
        A: next_state = (in == 1'b0)? A : B;
        B: next_state = (in == 1'b0)? C : B;
        C: next_state = (in == 1'b0)? A : D;
        D: next_state = (in == 1'b0)? C : B;
        default: next_state = A;
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule