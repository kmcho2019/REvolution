module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// State transition logic
always @(*) begin
    case(state)
        A: next_state = (in)? B : A;
        B: next_state = (in)? B : C;
        C: next_state = (in)? D : A;
        D: next_state = (in)? B : C;
        default: next_state = A; // default to state A
    endcase
end

// Output logic
always @(*) begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // default output to 0
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= A; // reset to state A
    end else begin
        state <= next_state; // update state
    end
end

endmodule