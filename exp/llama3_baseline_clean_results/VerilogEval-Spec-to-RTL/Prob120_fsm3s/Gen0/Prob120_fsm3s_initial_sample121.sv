module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, nextState;

// State transition logic
always_comb begin
    case(state)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
        default: nextState = A; // Default to state A
    endcase
end

// Output logic
always_comb begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default output to 0
    endcase
end

// Synchronous reset logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= A; // Reset state to A
    end else begin
        state <= nextState; // Update state
    end
end

endmodule